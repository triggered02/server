# Bedrock Voice Chat for Hytale Servers

This guide covers the installation and configuration of Bedrock Voice Chat (BVC) for Hytale servers.

> Hytale Support is very early. You will likely encounter issues or bugs.

## Overview

BVC enables proximity-based voice chat for Hytale servers, allowing players to communicate based on their in-game location. The plugin supports two deployment modes to fit different server setups.

## Server Modes

**External Server Mode**: Connects to a separate BVC server instance running independently. This is recommended for:
- Production environments
- Hosting multiple game servers
- Distributed server architectures

**Embedded Server Mode**: Runs the BVC server directly within your Hytale server. This is ideal for:
- Single-server setups
- Local development and testing
- Simplified deployment

---

## Installation

1. Download the BVC Hytale plugin
2. Place the plugin in your Hytale server's `mods` directory
3. Start your server once to generate the default configuration file
4. Stop the server and configure BVC (see Configuration section below)
5. Restart your server

---

## Configuration

The configuration file is located at:

```
mods\com.alaydriem_bedrock-voice-chat\BedrockVoiceChatPlugin.json
```

### External Server Mode

Use this configuration when connecting to a separate BVC server instance:

```json
{
  "BvcServer": "https://your-bvc-server.example.com:8444",
  "AccessToken": "<REPLACE_WITH_YOUR_ACCESS_TOKEN>",
  "MinimumPlayers": 1,
  "UseEmbeddedServer": false
}
```

**Configuration Steps:**
1. Set `BvcServer` to your external BVC server's URL (including port)
2. Set `AccessToken` to the token provided by your BVC server administrator
3. Adjust `MinimumPlayers` based on your needs (voice chat activates when this threshold is reached)
4. Keep `UseEmbeddedServer` set to `false`

### Embedded Server Mode

Use this configuration to run the BVC server within your Hytale server:

```json
{
  "BvcServer": "",
  "AccessToken": "<GENERATE_A_SECURE_TOKEN>",
  "MinimumPlayers": 1,
  "UseEmbeddedServer": true,
  "EmbeddedConfig": {
    "HttpPort": 8444,
    "QuicPort": 8443,
    "PublicAddr": "your.server.ip.address",
    "BroadcastRange": 48.0,
    "TlsCertificate": "/path/to/certificate-chain.pem",
    "TlsKey": "/path/to/private-key.pem",
    "TlsNames": "127.0.0.1,your.server.ip.address,your.domain.com",
    "TlsIps": "127.0.0.1,your.server.ip.address",
    "LogLevel": "info"
  }
}
```

**Configuration Steps:**
1. Leave `BvcServer` empty (or set it to your public address for client reference)
2. Generate a secure `AccessToken` (use a random string generator)
3. Set `UseEmbeddedServer` to `true`
4. Configure the `EmbeddedConfig` section (see parameters below)

---

## Configuration Parameters

### Core Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `BvcServer` | string | External server URL (external mode) or empty/public address (embedded mode) |
| `AccessToken` | string | Authentication token for secure communication |
| `MinimumPlayers` | integer | Minimum players required before voice chat activates |
| `UseEmbeddedServer` | boolean | `true` for embedded mode, `false` for external mode |

### Embedded Server Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `HttpPort` | integer | HTTP/HTTPS port for web interface and API | 8444 |
| `QuicPort` | integer | QUIC protocol port for voice data transmission | 8443 |
| `PublicAddr` | string | Public IP address or hostname where clients connect | - |
| `BroadcastRange` | float | Maximum voice chat distance in blocks | 48.0 |
| `TlsCertificate` | string | Path to TLS certificate chain file (PEM format) | - |
| `TlsKey` | string | Path to TLS private key file (PEM format) | - |
| `TlsNames` | string | Comma-separated list of valid hostnames/IPs for TLS | - |
| `TlsIps` | string | Comma-separated list of valid IP addresses for TLS | - |
| `LogLevel` | string | Logging verbosity: `debug`, `info`, `warn`, `error` | info |

---

## TLS Certificate Setup

For embedded mode, you'll need valid TLS certificates. You can:

### Option 1: Let's Encrypt (Recommended)
- Free, automated certificates
- Requires a domain name
- Certificates auto-renew

### Option 2: Commercial Certificate
- Purchase from a certificate authority
- Provides maximum compatibility

**Certificate File Paths:**
- Windows: Use double backslashes `\\` or forward slashes `/`
  - Example: `C:\\certs\\certificate.pem` or `C:/certs/certificate.pem`
- Linux: Use standard paths
  - Example: `/etc/letsencrypt/live/yourdomain.com/fullchain.pem`

---

## Network Configuration

### Port Forwarding

If running embedded mode, ensure these ports are open and forwarded:

| Port | Protocol | Purpose |
|------|----------|---------|
| 8444 | TCP | HTTPS (web interface and API) |
| 8443 | UDP | QUIC (voice data) |

### Firewall Rules

Allow incoming connections on:
- TCP port 8444
- UDP port 8443

### Public Address

The `PublicAddr` should be:
- Your server's public IP address (e.g., `203.0.113.45`)
- Or your server's domain name (e.g., `hytale.example.com`)
- **NOT** a private IP (192.168.x.x, 10.x.x.x) unless testing locally

---

## Example Configurations

### Development/Testing (Local)

```json
{
  "BvcServer": "",
  "AccessToken": "dev-token-12345",
  "MinimumPlayers": 1,
  "UseEmbeddedServer": true,
  "EmbeddedConfig": {
    "HttpPort": 8444,
    "QuicPort": 8443,
    "PublicAddr": "127.0.0.1",
    "BroadcastRange": 48.0,
    "TlsCertificate": "C:/dev/certs/localhost.pem",
    "TlsKey": "C:/dev/certs/localhost-key.pem",
    "TlsNames": "127.0.0.1,localhost",
    "TlsIps": "127.0.0.1",
    "LogLevel": "debug"
  }
}
```

### Production (Public Server)

```json
{
  "BvcServer": "",
  "AccessToken": "prod-secure-token-xyz789",
  "MinimumPlayers": 2,
  "UseEmbeddedServer": true,
  "EmbeddedConfig": {
    "HttpPort": 8444,
    "QuicPort": 8443,
    "PublicAddr": "hytale.example.com",
    "BroadcastRange": 64.0,
    "TlsCertificate": "/etc/letsencrypt/live/hytale.example.com/fullchain.pem",
    "TlsKey": "/etc/letsencrypt/live/hytale.example.com/privkey.pem",
    "TlsNames": "hytale.example.com",
    "TlsIps": "203.0.113.45",
    "LogLevel": "info"
  }
}
```

---

## Troubleshooting

### Voice chat not working

1. **Check minimum players**: Ensure you have enough players online (set by `MinimumPlayers`)
2. **Verify ports**: Confirm ports 8443 and 8444 are open and forwarded
3. **Check logs**: Set `LogLevel` to `debug` for detailed information
4. **Certificate issues**: Verify TLS certificate paths are correct and files are readable

### Connection errors

1. **Public address**: Ensure `PublicAddr` matches your actual public IP/domain
2. **Firewall**: Check that your firewall allows UDP traffic on port 8443
3. **TLS names**: Verify `TlsNames` includes all addresses clients might use to connect

<!-- metadata
title: "Bedrock Voice Chat for Hytale Servers"
topic: hytale
tags: rag
-->
