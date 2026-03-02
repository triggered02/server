# Bedrock Voice Chat on Linux (Quick Install Guide)

If your goal is **"I want to learn how to install it on Linux"**, start here.

This repository includes a local mirror of the upstream wiki:

- Source wiki: https://github.com/Alaydriem/bedrock-voice-chat.wiki.git
- Mirror path: `docs/bedrock-voice-chat-wiki/`
- Full guide: `docs/bedrock-voice-chat-wiki/BVC-Server-Installation.md`

## Prerequisites

- A Linux server with a public IP (VPS or dedicated host).
- A domain name pointing to your server.
- TLS certificate files for your domain.
- Bedrock Voice Chat server binary for Linux.

## Linux installation steps

1. **Create the install folder**

   ```bash
   sudo mkdir -p /opt/bvc
   sudo chown "$USER":"$USER" /opt/bvc
   ```

2. **Download or upload the Linux server binary** into `/opt/bvc`.

3. **Create `/opt/bvc/config.hcl`**

   Use the same structure documented in the wiki page and set:
   - your public hostname in `server.tls.names`
   - your public IP in `server.tls.ips`
   - certificate and key paths in `server.tls`
   - a strong `minecraft.access_token`

4. **Create the systemd service** at `/etc/systemd/system/bedrock-voice-chat.service`:

   ```ini
   [Unit]
   Description=Bedrock Voice Chat Service
   After=network.target

   [Service]
   Type=simple
   ExecStart=/opt/bvc/bedrock-voice-chat-server server --config-file /opt/bvc/config.hcl
   Restart=always
   WorkingDirectory=/opt/bvc
   KillSignal=SIGTERM
   KillMode=mixed
   TimeoutStopSec=5s

   [Install]
   WantedBy=multi-user.target
   ```

5. **Enable and start the service**

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now bedrock-voice-chat
   ```

6. **Verify logs**

   ```bash
   sudo journalctl -u bedrock-voice-chat -f
   ```

## Important notes

- Open/forward the port you configure for BVC (commonly `443`).
- You must use the expected Azure Client ID documented in the upstream wiki when configuring auth.
- If your Minecraft server cannot run custom executables directly, host BVC separately.

## Next docs to read

- `docs/bedrock-voice-chat-wiki/BVC-Server-Installation.md`
- `docs/bedrock-voice-chat-wiki/BDS-Server-Pack-Installation.md`
- `docs/bedrock-voice-chat-wiki/Logging-In-to-Bedrock-Voice-Chat-Client.md`

## Refreshing the wiki mirror

```bash
rm -rf /tmp/bedrock-voice-chat.wiki
git clone https://github.com/Alaydriem/bedrock-voice-chat.wiki.git /tmp/bedrock-voice-chat.wiki
rsync -a --delete --exclude='.git' /tmp/bedrock-voice-chat.wiki/ docs/bedrock-voice-chat-wiki/
```
