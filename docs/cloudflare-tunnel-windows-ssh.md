# Cloudflare Tunnel → Windows OpenSSH

A practical guide for securely reaching a Windows PC over SSH through a Cloudflare Tunnel, without opening inbound port 22 on the home router.

> **Scope:** This guide assumes the Windows PC and domain are yours or you have permission to administer them.

## Architecture

```text
SSH client
   |
   | SSH + cloudflared
   v
Cloudflare
   |
   | outbound tunnel
   v
Windows PC
   |
   +--> OpenSSH Server :22
```

Cloudflare Tunnel uses an outbound connection from `cloudflared`, so the home router does not need an inbound SSH port-forward. Cloudflare documents SSH as a supported non-HTTP service, with `cloudflared` required on the client side as well. See the official docs:

- https://developers.cloudflare.com/tunnel/
- https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/

---

## 1. Prerequisites

You need:

- A Cloudflare account.
- A domain managed by Cloudflare. Cloudflare's current Tunnel setup requires a domain for publishing applications.
- A Windows 10/11 PC with Internet access.
- Administrator access to the Windows PC.
- `cloudflared` installed on the Windows PC.
- `cloudflared` installed on the SSH client.

Official setup documentation:
https://developers.cloudflare.com/tunnel/setup/

---

# Part A — Windows OpenSSH Server

## 2. Install OpenSSH Server

Open **PowerShell as Administrator** on the Windows PC:

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

Start the SSH service and configure it to start automatically with Windows:

```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
```

Check it:

```powershell
Get-Service sshd
```

You want the service state to be `Running`.

## 3. Verify the local SSH server

From the Windows PC itself:

```powershell
ssh localhost
```

Log in with your Windows account.

If this works, OpenSSH is functioning before Cloudflare is introduced.

## 4. Check that SSH is listening

```powershell
Get-NetTCPConnection -LocalPort 22 -State Listen
```

You should see TCP port `22` listening.

Windows normally creates the required OpenSSH firewall rule during installation. If the rule is missing, create it from an elevated PowerShell:

```powershell
New-NetFirewallRule -Name sshd -DisplayName "OpenSSH Server (sshd)" `
  -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

**Do not forward port 22 on your home router.** The point of this setup is for the Cloudflare connector to make the outbound connection.

---

# Part B — Create the Cloudflare Tunnel

## 5. Create a remotely-managed tunnel

Cloudflare currently recommends remotely-managed tunnels for most deployments because their configuration is stored in Cloudflare and can be managed from the dashboard.

Open:

https://dash.cloudflare.com/

Go to:

**Networking → Tunnels → Create a tunnel**

Choose **Cloudflared**, give the tunnel a name such as:

```text
home-windows-ssh
```

Select the Windows operating system and the appropriate architecture.

Cloudflare will show an installation command containing a tunnel token.

### SECURITY WARNING

The tunnel token is a secret. Anyone who has the token can run a replica of that remotely-managed tunnel. Never commit the token to GitHub, paste it into a public issue, or include it in screenshots.

Official token documentation:
https://developers.cloudflare.com/tunnel/advanced/tunnel-tokens/

---

# Part C — Install cloudflared on Windows

## 6. Download cloudflared

Use Cloudflare's official download page:

https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/downloads/

Install the Windows version appropriate for your CPU architecture.

Verify the installation:

```powershell
cloudflared --version
```

---

## 7. Install the tunnel as a Windows service

Open **Command Prompt or PowerShell as Administrator**.

Cloudflare's current remotely-managed setup provides a command similar to:

```powershell
cloudflared.exe service install <TUNNEL_TOKEN>
```

Replace `<TUNNEL_TOKEN>` with the token shown by your Cloudflare dashboard.

Then start the service:

```powershell
Start-Service cloudflared
```

Check it:

```powershell
Get-Service cloudflared
```

The service should show:

```text
Status   Name
------   ----
Running  cloudflared
```

Installing `cloudflared` as a Windows service makes it start at boot and continue running in the background. Cloudflare documents the Windows service approach here:

https://developers.cloudflare.com/tunnel/advanced/local-management/as-a-service/windows/

Cloudflare also documents remotely-managed tunnel installation here:

https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/get-started/create-remote-tunnel/

---

# Part D — Publish SSH

## 8. Add the SSH route

In the Cloudflare dashboard, open your tunnel and add a **Published application** route.

Use:

```text
Hostname: ssh.yourdomain.com
Service type: SSH
Service URL: ssh://localhost:22
```

For example, if your domain is `example.com`:

```text
ssh.example.com
    -> ssh://localhost:22
```

Cloudflare creates the DNS routing for the hostname through the tunnel.

Do **not** substitute an HTTP service such as `http://localhost:22`; SSH should be configured as an SSH service.

---

# Part E — Install cloudflared on the SSH client

## 9. Install cloudflared on the machine you connect FROM

Cloudflare's SSH implementation requires `cloudflared` on the client side as well as the Windows origin.

Install it using Cloudflare's official downloads:

https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/downloads/

Verify:

```bash
cloudflared --version
```

---

# Part F — Configure SSH

## 10. Add an SSH config entry

On Linux/macOS, edit:

```text
~/.ssh/config
```

On Windows OpenSSH, the equivalent is normally:

```text
%USERPROFILE%\.ssh\config
```

Add:

```sshconfig
Host home-pc
    HostName ssh.yourdomain.com
    User YOUR_WINDOWS_USERNAME
    ProxyCommand cloudflared access ssh --hostname %h
```

Replace:

```text
ssh.yourdomain.com
```

with your actual hostname and:

```text
YOUR_WINDOWS_USERNAME
```

with the Windows account you intend to use.

Then connect with:

```bash
ssh home-pc
```

You can also use the full hostname directly:

```bash
ssh YOUR_WINDOWS_USERNAME@ssh.yourdomain.com
```

provided your SSH configuration is set up to invoke `cloudflared` for that host.

---

# Part G — SSH Keys (Recommended)

## 11. Create an SSH key on the client

On Linux/macOS:

```bash
ssh-keygen -t ed25519
```

On modern Windows PowerShell with OpenSSH:

```powershell
ssh-keygen -t ed25519
```

Keep the private key on the client. **Never upload the private key to GitHub.**

The public key ends in `.pub` and can be added to the Windows account's authorized keys.

For Windows OpenSSH, the normal per-user location is:

```text
C:\Users\YOUR_USERNAME\.ssh\authorized_keys
```

For an administrator account, Windows OpenSSH can also use the administrators' authorized-keys file depending on the OpenSSH configuration. Check `C:\ProgramData\ssh\sshd_config` before changing anything.

After changing `sshd_config`, restart OpenSSH:

```powershell
Restart-Service sshd
```

---

# Part H — Administrator access

## 12. Understand Windows elevation

An SSH login does not automatically mean every process is elevated.

If the Windows account is an administrator, you can run an elevated PowerShell from the SSH session using normal Windows elevation mechanisms, for example:

```powershell
Start-Process powershell -Verb RunAs
```

However, `RunAs` may require an interactive UAC confirmation. Do **not** disable UAC globally just to make SSH convenient.

A safer approach is to use a dedicated administrative account only when necessary and keep normal accounts non-administrative.

For routine administration, you can also explicitly launch individual commands from an elevated PowerShell session rather than making every SSH process permanently elevated.

---

# Part I — Make sure everything survives reboot

## 13. Confirm both Windows services are automatic

Open elevated PowerShell:

```powershell
Get-Service sshd,cloudflared | Select-Object Name,Status,StartType
```

You want both services to show `Automatic` startup and normally `Running` status.

If needed:

```powershell
Set-Service sshd -StartupType Automatic
Set-Service cloudflared -StartupType Automatic
```

Restart Windows:

```powershell
Restart-Computer
```

After Windows boots, verify:

```powershell
Get-Service sshd,cloudflared
```

Both should be running.

---

# Part J — Troubleshooting

## 14. `ssh localhost` fails

Check OpenSSH:

```powershell
Get-Service sshd
```

Check port 22:

```powershell
Get-NetTCPConnection -LocalPort 22 -State Listen
```

Check the OpenSSH server configuration:

```text
C:\ProgramData\ssh\sshd_config
```

Restart after configuration changes:

```powershell
Restart-Service sshd
```

## 15. Cloudflare tunnel is unhealthy

Check:

```powershell
Get-Service cloudflared
```

If needed:

```powershell
Restart-Service cloudflared
```

Also check the tunnel's status in the Cloudflare dashboard.

If the home network has restrictive egress filtering, Cloudflare notes that the connector needs to reach its network, including port `7844`.

## 16. SSH connects but authentication fails

Verify the Windows username:

```powershell
whoami
```

Check whether the public key is in the correct `authorized_keys` file and verify the OpenSSH configuration.

Test normal password authentication first, then move to key authentication.

## 17. `cloudflared access ssh` is not found

Verify:

```bash
cloudflared --version
```

If the command is installed but not found, add its installation directory to `PATH` or use the full path in the SSH `ProxyCommand`.

Example:

```sshconfig
ProxyCommand C:\Path\To\cloudflared.exe access ssh --hostname %h
```

---

# Part K — Security checklist

Before using this as a permanent remote-admin connection:

- [ ] Do not expose router port `22`.
- [ ] Use a strong Windows account password.
- [ ] Prefer SSH keys.
- [ ] Protect the SSH private key with a passphrase.
- [ ] Keep Windows and OpenSSH updated.
- [ ] Keep `cloudflared` updated.
- [ ] Never publish the Cloudflare tunnel token.
- [ ] Never commit `.json` tunnel credentials or tokens to Git.
- [ ] Do not commit private SSH keys.
- [ ] Use Cloudflare Access policies if the SSH endpoint should be restricted to specific identities.
- [ ] Use a dedicated account for remote administration where practical.
- [ ] Avoid disabling UAC globally.

A tunnel removes the need for an inbound router port, but it does not make the SSH account itself magically safe. Treat the Windows credentials and SSH keys as sensitive credentials.

---

# Quick reference

### Windows: install OpenSSH

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service sshd -StartupType Automatic
```

### Windows: install Cloudflare Tunnel service

```powershell
cloudflared.exe service install <TUNNEL_TOKEN>
Start-Service cloudflared
Set-Service cloudflared -StartupType Automatic
```

### Windows: verify

```powershell
Get-Service sshd,cloudflared
```

### SSH client config

```sshconfig
Host home-pc
    HostName ssh.yourdomain.com
    User YOUR_WINDOWS_USERNAME
    ProxyCommand cloudflared access ssh --hostname %h
```

### Connect

```bash
ssh home-pc
```

---

## Official references

- Cloudflare Tunnel overview: https://developers.cloudflare.com/tunnel/
- Cloudflare Tunnel setup: https://developers.cloudflare.com/tunnel/setup/
- Cloudflare SSH use case: https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/
- Cloudflare Tunnel tokens: https://developers.cloudflare.com/tunnel/advanced/tunnel-tokens/
- Cloudflare Windows service: https://developers.cloudflare.com/tunnel/advanced/local-management/as-a-service/windows/
- Microsoft OpenSSH for Windows: https://learn.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse
