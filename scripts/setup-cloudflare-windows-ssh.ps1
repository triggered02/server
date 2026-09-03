#requires -RunAsAdministrator
<##
.SYNOPSIS
    Sets up Windows OpenSSH for Cloudflare Tunnel and installs cloudflared as a boot-time service.

.DESCRIPTION
    This script intentionally does NOT create SSH keys and does NOT disable UAC.
    It configures the local Windows side only. The Cloudflare dashboard still needs
    a remotely-managed tunnel and a Published Application route:

        SSH -> localhost:22

    Run this script in an elevated PowerShell window and paste the tunnel token when prompted.

.NOTES
    Password authentication is left available for OpenSSH. Use a strong Windows account password.
    The Cloudflare tunnel token is never written to this script or committed to Git.
#>

$ErrorActionPreference = 'Stop'

function Write-Step([string]$Message) {
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Get-CloudflaredPath {
    $cmd = Get-Command cloudflared.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $known = @(
        "$env:ProgramFiles\cloudflared\cloudflared.exe",
        "${env:ProgramFiles(x86)}\cloudflared\cloudflared.exe",
        "$env:LOCALAPPDATA\Microsoft\WinGet\Links\cloudflared.exe"
    )

    foreach ($path in $known) {
        if ($path -and (Test-Path $path)) { return $path }
    }

    return $null
}

Write-Step "Checking Administrator privileges"
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run PowerShell as Administrator and execute this script again.'
}

Write-Step "Installing Windows OpenSSH Server if necessary"
$openssh = Get-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
if ($openssh.State -ne 'Installed') {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 | Out-Host
}

Write-Step "Starting OpenSSH and enabling it at boot"
Set-Service -Name sshd -StartupType Automatic
Start-Service -Name sshd -ErrorAction SilentlyContinue

Write-Step "Ensuring Windows Firewall allows SSH on TCP 22"
$firewallRule = Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue
if (-not $firewallRule) {
    New-NetFirewallRule `
        -Name 'OpenSSH-Server-In-TCP' `
        -DisplayName 'OpenSSH Server (sshd)' `
        -Enabled True `
        -Direction Inbound `
        -Protocol TCP `
        -Action Allow `
        -LocalPort 22 | Out-Null
} else {
    Enable-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' | Out-Null
}

Write-Step "Checking local SSH listener"
$listening = Get-NetTCPConnection -LocalPort 22 -State Listen -ErrorAction SilentlyContinue
if (-not $listening) {
    throw 'OpenSSH is installed but TCP port 22 is not listening. Check the sshd service and C:\ProgramData\ssh\sshd_config.'
}
Write-Host 'SSH is listening on TCP 22.' -ForegroundColor Green

Write-Step "Installing cloudflared if it is not already installed"
$cloudflared = Get-CloudflaredPath
if (-not $cloudflared) {
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if (-not $winget) {
        throw 'cloudflared is not installed and winget is unavailable. Install cloudflared from Cloudflare, then rerun this script.'
    }

    Write-Host 'Installing Cloudflare.cloudflared with winget...' -ForegroundColor Yellow
    & $winget.Source install --id Cloudflare.cloudflared --exact --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) {
        throw "winget failed with exit code $LASTEXITCODE. Install cloudflared manually from https://developers.cloudflare.com/tunnel/downloads/ and rerun this script."
    }

    $cloudflared = Get-CloudflaredPath
}

if (-not $cloudflared) {
    throw 'cloudflared was installed but could not be located in PATH. Open a new Administrator PowerShell and rerun this script.'
}

Write-Host "Using: $cloudflared" -ForegroundColor Green
& $cloudflared --version

Write-Step "Getting the Cloudflare Tunnel token"
Write-Host 'In Cloudflare Dashboard: Networking -> Tunnels -> your tunnel -> Add a replica.' -ForegroundColor Yellow
Write-Host 'Copy ONLY the token (the eyJ... value) from the cloudflared installation command.' -ForegroundColor Yellow
Write-Host 'Do not paste the token into GitHub, screenshots, or this script.' -ForegroundColor Yellow

$secureToken = Read-Host 'Paste tunnel token' -AsSecureString
$tokenPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
try {
    $token = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($tokenPtr)
} finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($tokenPtr)
}

if ([string]::IsNullOrWhiteSpace($token)) {
    throw 'No tunnel token was supplied.'
}

Write-Step "Installing cloudflared as a Windows service"
$existing = Get-Service -Name Cloudflared -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host 'An existing Cloudflared service was found. Removing it before reinstalling with the supplied token.' -ForegroundColor Yellow
    try {
        & $cloudflared service uninstall | Out-Host
    } catch {
        Write-Host 'The existing service could not be removed automatically. If installation fails, run: cloudflared.exe service uninstall' -ForegroundColor Yellow
    }
    Start-Sleep -Seconds 2
}

& $cloudflared service install $token
if ($LASTEXITCODE -ne 0) {
    throw "cloudflared service installation failed with exit code $LASTEXITCODE."
}

# The service is intended to run at boot. Explicitly enforce Automatic startup.
Set-Service -Name Cloudflared -StartupType Automatic
Start-Service -Name Cloudflared

# Do not retain the token in a normal PowerShell variable longer than necessary.
$token = $null

Write-Step "Final checks"
$sshService = Get-Service -Name sshd
$cfService = Get-Service -Name Cloudflared

Write-Host "`nOpenSSH : $($sshService.Status) / $($sshService.StartType)" -ForegroundColor Green
Write-Host "Cloudflared: $($cfService.Status) / $($cfService.StartType)" -ForegroundColor Green

if ($sshService.Status -ne 'Running') {
    throw 'OpenSSH is not running.'
}
if ($cfService.Status -ne 'Running') {
    throw 'Cloudflared is not running. Check the Windows Event Viewer and Cloudflare Tunnel dashboard.'
}

Write-Host @"

SETUP COMPLETE

Windows SSH:
  localhost:22

Services:
  sshd        -> Automatic
  Cloudflared -> Automatic

Next:
  1. In Cloudflare, add a Published Application route.
  2. Hostname: ssh.YOUR-DOMAIN
  3. Service:  SSH
  4. URL:      localhost:22
  5. On the client, install cloudflared and configure SSH ProxyCommand.

This script did NOT create SSH keys and did NOT disable UAC.
Do not expose TCP 22 through your home router.
"@ -ForegroundColor Green
