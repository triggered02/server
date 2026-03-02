Bedrock Voice Chat utilizes dedicated server component that coordinates player state for all players and transmits message such as Audio packets, player positioning data, and more, and must be installed on a dedicated Linux or Windows computer that is publicly accessible.

> This document outlines the server requirements and details how to install BVC on a Linux server or Docker container. Partner with either our dedicated hosting program or a dedicated system administrator to help you harden your installation and protect it from malicious attacks.

## Bedrock Voice Chat as a Service

Don't want to manage your own BVC server? Consider our hosted option, coming soon.

## Promoted Hosting Providers

The following cloud hosting providers provide cost-effective Linux servers for you to run BVC on. If you are looking for a hosting provider, please consider using one of the referral links provided.

- [DigitalOcean](https://m.do.co/c/15e066af535c)

Signing up with Digital Ocean will give you a $200 credit after your first $25 spend, which is nearly 8 months of hosting you can have for free on a 4GB/2vcpu basic node, perfect for servers that don't have many concurrent players online at the same time.

- [Hetzner](https://hetzner.cloud/?ref=StImwLqshuwn)

Hetzner provides a $25 signup credit which you can use immediately

## Recommended Server Sizing

Bedrock Voice chat is _primarily_ CPU bound -- performance issues can generally be solved by increasing the number of CPU cores as opposed to memory. I recommend having at least 2 vcpus for smaller servers, then scaling up from there.

## Linux/Windows Server General Installation

1. Download the bedrock voice chat server for your platform, and upload it to the `/opt/bvc` directory -- creating it if necessary.
2. Procure a domain name, and direct an A record to the IP address of your server. Consider Cloudflare as a free DNS provider, and namecheap as a domain registrar.
3. Procure a TLS certificate via CertBot, WinAcme, or any other ACME provider. 
4. In your directory where the server is downloaded to, create a config.hcl file with the following configuration. Be sure to replace any outlined values:

```hcl

# This Configuration will work with Beta.2
# Beta.1 Configuration can be accessed by viewing this page's history

server {
    # Set this to :443 for convenience. If you're proxying BVC you can change this, just be aware that clients will need to manually enter the port
    port = 443
    tls {
        names = [
            "127.0.0.1",
            # Replace with your actual public IP(s)
            "203.0.113.1",
            # The public hostname you want players to access Bedrock Voice Chat from
            "your.hostname.tld"
        ]
        ips  = [
            "127.0.0.1",
            # Replace with your actual public IP(s)
            "203.0.113.1"
        ]
        certificate = "/path/to/certificate-chain.pem"
        key = "/path/to/certificate-key.pem"
    }

    minecraft {
        # Generate a 32 alphanumberic password from https://bitwarden.com/password-generator/
        access_token = "AnskfLqzP3vP3GgZZrpYLNj6xBNJ4F2LEbCT"
    }
}
```

5. Create a systemd file to manager the server to /etc/systemd/system/bedrock-voice-chat.service

```
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
WantedBy=multi-user.targe
```

And enable it via `systemctl enable bedrock-voice-chat`.

I recommend you also have a timer installed and synced to your BDS restart time.

```
[Unit]
Description=Timer to restart Bedrock Voice Chat at 9AM and 9PM CT daily

[Timer]
OnCalendar=*-*-* 14:00:00
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

> Restarting the server will kick any active clients. Clients can reconnect manually using the refresh button in the BVC client view
> BVC can run indefinitely, however it is recommended to periodically restart it.

Once BVC is running you can inspect the logs via journalctl -xf -u bedrock-voice-chat to ensure it's running, then connect to it from your client.

## Azure Client ID
Bedrock Voice Chat uses a single Microsoft OAuth2 client for authentication. In your server config you MUST use `a17f9693-f01f-4d1d-ad12-1f179478375d` to validate players.

Here are the permissions that will be requested.
<img width="1001" height="167" alt="Screenshot 2026-01-13 at 11 10 24" src="https://github.com/user-attachments/assets/9e60b5ea-4902-4516-b23b-b8a0e2db2154" />

## Player Allowlist

Bedrock Voice Chat by default has a deny-all approach - only users who your server sends over can login and connect to voice chat. Users can be whitelisted manually by using the following command

```
bedrock-voice-chat-server user add --player test --game hytale|minecraft
```

## Docker Installation

<!-- metadata
title: "BVC Server Installation Guide"
topic: server-installation
tags: rag
see_also:
  - label: "Realms Support"
    url: "https://github.com/Alaydriem/bedrock-voice-chat/wiki/Realms-and-Multiplayer-Worlds"
  - label: "Local and Locally Hosted Worlds"
    url: "https://github.com/Alaydriem/bedrock-voice-chat/wiki/Local-and-Self-Hosted-Worlds"
-->
