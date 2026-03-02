# Server Configuration

For cross-platform servers, Bedrock Voice Chat supports server-side positioning data to be relayed from Java servers.

BVC should work with any Java servers running Fabric or PaperMC (with more support for other launchers coming soon). Game servers that utilize Geyser or similar tools can take advantage of BVC as well.

## Server Modes

BVC supports two deployment modes:

**External Server Mode**: Connects to a separate BVC server instance running independently. This is recommended for production environments or when hosting multiple game servers, or if you have many players (15-20+)

**Embedded Server Mode**: Runs the BVC server directly within your game server plugin/mod. This is convenient for single-server setups and local development, and servers with only a few players on them.

---


# Installation via Modrinth

The Java servers [Modrinth](https://modrinth.com/mod/bedrock-voice-chat) for convenience.

# Fabric Servers

### Manual Installation

1. Download and add [fabric-api](https://modrinth.com/mod/fabric-api?version=1.21.11) to your server's `mods` folder
2. Download and add `bedrock-voice-chat.jar` to your server's `mods` folder
3. Create `config/bedrock-voice-chat.json` with your configuration (see below)
4. Start your Java server normally

### Configuration

**External Server Mode:**

```json
{
  "bvc-server": "https://your-bvc-server-fqdn.tld:8444",
  "access-token": "<REPLACE_WITH_YOUR_ACCESS_TOKEN>",
  "minimum-players": 2,
  "use-embedded-server": false
}
```

**Embedded Server Mode:**

```json
{
  "bvc-server": "https://your-server-address:8444",
  "access-token": "<REPLACE_WITH_YOUR_ACCESS_TOKEN>",
  "minimum-players": 2,
  "use-embedded-server": true,
  "embedded-config": {
    "http-port": 8444,
    "quic-port": 8443,
    "public-addr": "your.server.ip.address",
    "broadcast-range": 32.0,
    "tls-certificate": "/path/to/certificate-chain.pem",
    "tls-key": "/path/to/private-key.pem",
    "tls-names": ["127.0.0.1", "your.server.ip.address", "your.domain.tld"],
    "tls-ips": ["127.0.0.1", "your.server.ip.address"],
    "log-level": "info"
  }
}
```

---

# PaperMC Servers

### Installation

1. Download the PaperMC plugin
2. Add the plugin JAR to your server's `plugins` directory
3. Create the `plugins/BedrockVoiceChat` directory
4. Create `plugins/BedrockVoiceChat/config.yaml` with your configuration (see below)
5. Start/restart your server

### Configuration

**External Server Mode:**

```yaml
bvc-server: "https://your-bvc-server-fqdn.tld:8444"
access-token: "<REPLACE_WITH_YOUR_ACCESS_TOKEN>"
minimum-players: 2
use-embedded-server: false
```

**Embedded Server Mode:**

```yaml
bvc-server: "https://your-server-address:8444"
access-token: "<REPLACE_WITH_YOUR_ACCESS_TOKEN>"
minimum-players: 2
use-embedded-server: true

embedded:
  http-port: 8444
  quic-port: 8443
  public-addr: "your.server.ip.address"
  broadcast-range: 32.0
  tls-certificate: "/path/to/certificate-chain.pem"
  tls-key: "/path/to/private-key.pem"
  tls-names:
    - 127.0.0.1
    - your.server.ip.address
    - your.domain.tld
  tls-ips:
    - 127.0.0.1
    - your.server.ip.address
  log-level: info
```

---

# Geyser Compatibility

BVC runs on Geyser servers using a supported launcher such as Fabric or PaperMC. Configure your Java mod/plugin as you would normally, then have clients connect to your BVC server instance. Clients should be able to hear each other normally.

---

# Simple Voice Chat Integration

Currently Bedrock Voice Chat does not integrate with simple voice chat, however Java and Bedrock players can communicate across games using the plugins listed here, and the Bedrock Voice Chat apps.

# Support

Please report any issues with Java mods or plugins as [GitHub issues](https://github.com/your-repo/issues).

<!-- metadata
title: "Minecraft Java Server Support for BVC"
topic: java-server
tags: rag
-->
