# Cloudflare Tunnel → Windows SSH (Password-Only)

This is the **no-SSH-key** version. The setup uses your normal Windows account password for SSH authentication.

## What this automates

The included PowerShell script:

- Requires Administrator PowerShell.
- Installs Windows OpenSSH Server if needed.
- Enables `sshd` and makes it start at boot.
- Ensures the Windows firewall permits TCP 22 locally.
- Installs `cloudflared` with WinGet when available.
- Prompts for your Cloudflare Tunnel token without putting it in the script.
- Installs `cloudflared` as a Windows service.
- Makes the Cloudflare service start automatically at boot.
- Starts both services and verifies them.
- **Does not create SSH keys.**
- **Does not disable UAC.**

Cloudflare documents `cloudflared` as a Windows service that starts at boot, and its current dashboard setup supports installing a remotely-managed tunnel with a tunnel token. SSH published through Tunnel requires `cloudflared` on the client as well. 

## 1. Create the tunnel in Cloudflare

In Cloudflare Dashboard:

**Networking → Tunnels → Create Tunnel**

Create a Cloudflared tunnel.

Then open the tunnel and add a **Published application** route:

```text
Hostname: ssh.YOURDOMAIN.com
Service:  SSH
URL:      localhost:22
```

For the domain shown in the user's Cloudflare account, the hostname could be something like:

```text
ssh.triggeredhosts.space
```

## 2. Get the tunnel token

In the tunnel dashboard, use **Add a replica** and copy the `cloudflared` installation command into a temporary text editor.

The token is the long `eyJ...` value in that command.

**Never commit the token to GitHub or paste it into this documentation.** Anyone who has a remotely-managed tunnel token can run a replica of the tunnel.

## 3. Run the automatic Windows setup

Download/clone this repository, then open **PowerShell as Administrator**.

From the repository folder:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup-cloudflare-windows-ssh.ps1
```

When prompted, paste the Cloudflare tunnel token.

The script will do the Windows-side setup automatically.

## 4. Confirm the services

After the script completes:

```powershell
Get-Service sshd,Cloudflared
```

Both should be `Running`.

The startup type should be `Automatic`.

## 5. Connect from another computer

Install `cloudflared` on the client machine too.

Create/edit the SSH config:

```text
~/.ssh/config
```

Add:

```sshconfig
Host home-pc
    HostName ssh.YOURDOMAIN.com
    User YOUR_WINDOWS_USERNAME
    ProxyCommand cloudflared access ssh --hostname %h
```

Then:

```bash
ssh home-pc
```

Enter the Windows account password when SSH asks for it.

No SSH key is required by this guide.

## 6. Important: admin access

If the Windows account is an Administrator, SSH can log into that account, but Windows elevation/UAC is a separate mechanism. Do not disable UAC just to make remote administration easier.

First verify ordinary SSH works. Then use normal Windows administrative elevation only when needed.

## 7. Reboot test

On the Windows PC:

```powershell
Restart-Computer
```

After Windows comes back:

```powershell
Get-Service sshd,Cloudflared
```

Both services should start automatically.

Then test:

```bash
ssh home-pc
```

## Troubleshooting

### OpenSSH is not running

```powershell
Get-Service sshd
Start-Service sshd
```

### Port 22 is not listening

```powershell
Get-NetTCPConnection -LocalPort 22 -State Listen
```

### Cloudflared is not running

```powershell
Get-Service Cloudflared
Restart-Service Cloudflared
```

### Tunnel is disconnected

Check the tunnel status in Cloudflare Dashboard. Also make sure the Windows machine can make outbound connections to Cloudflare.

### Password login fails

Check the Windows username:

```powershell
whoami
```

Make sure the account has a Windows password and that OpenSSH password authentication has not been disabled in:

```text
C:\ProgramData\ssh\sshd_config
```

After changing `sshd_config`:

```powershell
Restart-Service sshd
```

## Security

- Do not forward TCP 22 on your home router.
- Do not put the Cloudflare tunnel token in this repository.
- Do not commit passwords.
- Use a strong Windows password.
- Keep Windows and `cloudflared` updated.
- Do not disable UAC globally.

## Official documentation

- Cloudflare Tunnel setup: https://developers.cloudflare.com/tunnel/setup/
- Cloudflare SSH: https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/
- Cloudflare Windows service: https://developers.cloudflare.com/tunnel/advanced/local-management/as-a-service/windows/
- Cloudflare tunnel tokens: https://developers.cloudflare.com/tunnel/advanced/tunnel-tokens/
- Microsoft OpenSSH for Windows: https://learn.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse
