<div align="center">

  <h1>Getting Started with Bedrock Voice Chat</h1>

<a href="https://www.youtube.com/@Alaydriem"><img src="https://img.shields.io/youtube/channel/subscribers/UCXgqRZv7bHsKzwYBrtA9DFA?label=Youtube%20Subscribers&logo=Alaydriem&style=flat-square" width="140"/></a>

<a href="https://discord.gg/CdtchD5zxr"><img src="https://raw.githubusercontent.com/Alaydriem/bedrock-voice-chat/master/client/static/images/app-logo-transparent.png" width="140"/></a>

  <p>
    <strong>A High Performance, Low Latency, Secure Voice Chat server for Minecraft Bedrock Dedicated Servers</strong>
  </p>
  <hr />
</div>

Welcome to Bedrock Voice Chat (BVC)! This is a proximity voice chat system for Minecraft Bedrock, Minecraft Java, and other games (such as Hytale) that lets players talk to each other based on how close they are in-game. BVC is cross-platform (works with both Bedrock and Java editions) and cross-device (supports PC, consoles, and mobile).

### How You Can Support!

There's lots of ways you can support the development of Bedrock Voice Chat. Supporting BVC's development enables us to 

- Release new features faster
- Address defects or other bugs more timely
- Add support for more games
- Add support for more launchers / loaders
- and more

Supporters and Sponsors also get early access to new features before everyone else does, so it's a great deal for everyone! If you're curious about how you can support, be sure to check out the pinned discussion for more details at: https://github.com/Alaydriem/bedrock-voice-chat/discussions/31

Patreon: https://www.patreon.com/posts/i-made-proximity-147533371?utm_medium=clipboard_copy&utm_source=copyLink&utm_campaign=postshare_creator&utm_content=join_link
YouTube Membership: https://www.youtube.com/channel/UCXgqRZv7bHsKzwYBrtA9DFA/join

<hr />

### How BVC Works

BVC consists of three separate components that work together:

1. The Server behavior pack or mod that installs on your Minecraft server. This tracks where players are in your game world and sends that positioning data to the BVC Server. You'll install either:

- The behavior pack for Bedrock Dedicated Servers (BDS), OR
- The Fabric mod for Java servers
- An appropriate mod for your game

2. The BVC Server - a standalone application written in Rust that handles all the voice processing. This is the heart of the system and runs completely separate from your Minecraft server. It receives player positions from your game server and processes all the audio data from connected players. This is a mandatory component - nothing works without it running.

3. The Client Apps (Windows, iOS, Android) that your players install on their devices. These apps connect directly to your BVC Server (not your Minecraft server) to send and receive voice data.

Here's the important part: the BVC Server is NOT a plugin or mod - it's its own standalone executable that you need to run on a dedicated machine. Most commercial Minecraft hosting providers don't allow you to run custom executables like this, so you'll need to run it on your own hardware, a VPS, or a separate hosting service.


<hr />

### Installation Steps - Follow This Order

If you're a visual person, there's also an installation video available over on Youtube: https://www.youtube.com/watch?v=0ciAc_d81a0

#### Step 1: Install the addon or mod on your Minecraft server

Pick the guide that matches your server type:

Bedrock Dedicated Server: [BDS Server Pack Installation](https://github.com/Alaydriem/bedrock-voice-chat/wiki/BDS-Server-Pack-Installation)
Java/Fabric Server: [Minecraft Java Support](https://github.com/Alaydriem/bedrock-voice-chat/wiki/Minecraft-Java-Support)

All assets are available on the Github Releases page for the latest release. Be sure to scroll down to the `Assets` section to download the appropriate files for your platform.

This step gets your game server ready to send player positioning data to the BVC Server.

#### Step 2: Set up and run the BVC Server

This is mandatory - follow the [BVC Server Installation](https://github.com/Alaydriem/bedrock-voice-chat/wiki/BVC-Server-Installation) guide.

The BVC Server needs to:

- Run on a machine you have access to (your own computer, VPS, dedicated server, k8 cluster)
- Be publicly accessible from the internet (requires port forwarding and firewall configuration)
- Stay running whenever you want players to use voice chat
- Have a domain name or static IP address that players can connect to
- Have a valid TLS certificate issued to it via ACME or a certificate provider

You'll need to configure it with an access token and tell your Minecraft server where the BVC Server is located.

#### Step 3: Whitelist Your Players

Once both your Minecraft server and BVC Server are running, operators can whitelist players following the guide here: [Logging In to Bedrock Voice Chat Client](https://github.com/Alaydriem/bedrock-voice-chat/wiki/Logging-In-to-Bedrock-Voice-Chat-Client). Make sure you do this before inviting players

#### Step 4: Have your players download and install the client apps.

##### Desktop 

Desktop players can download the `bvc-windows-client-x64.exe` app from the [Github Releases](https://github.com/Alaydriem/bedrock-voice-chat/releases) page. This is a portable, standalone executable you can run.

Support for other platforms like MacOS and Linux will be coming soon.

##### Console (Xbox, Switch, Playstation)

Console players use the mobile app for voice chat. Please reference the mobile section.

##### Mobile

Console and Mobile players can access their apps through the Google Play and iOS App Store.

###### Android

Android Google Play Store invites for early testing are being sent out daily. Head over to [Discord](https://discord.gg/MAHckcEATj), join the #bedrock-voice-chat-discussion forum and see the pinned post for Android early access.

###### iOS/iPad

I'll release the iOS app once we reach our funding/membership goal. Right now we need Patreons, Youtube Memberships, or Twitch Subs at the Supporter or Sponsor level to help cover some of the legal and administrative costs with releasing and more importantly maintaning an iOS App Store release. 

Patreon: https://www.patreon.com/posts/i-made-proximity-147533371?utm_medium=clipboard_copy&utm_source=copyLink&utm_campaign=postshare_creator&utm_content=join_link
YouTube Membership: https://www.youtube.com/channel/UCXgqRZv7bHsKzwYBrtA9DFA/join

If you want to help with that process the links are 👆. The sooner we reach that goal the sooner we can get that process going. The Supporter + Sponsor Tiers will be getting access to these additional feature first.

<hr />

#### Troubleshooting: If things aren't working, verify that:

- Your Minecraft server addon/mod is installed and configured with the correct BVC Server address
- The BVC Server is running and accessible from the internet
- Your firewall and port forwarding are configured correctly
- Players are connecting to the BVC Server (not your Minecraft server)

Still stuck? Make sure you completed all three steps in order before asking for help. The most common issue is the BVC Server not being accessible or not running. Head over to [Discord](https://discord.gg/MAHckcEATj) for additional support, or open a Github issue.

<!-- metadata
title: "Getting Started with Bedrock Voice Chat"
topic: getting-started
tags: rag
see_also:
  - label: "Realms Support"
    url: "https://github.com/Alaydriem/bedrock-voice-chat/wiki/Realms-and-Multiplayer-Worlds"
  - label: "Local and Locally Hosted Worlds"
    url: "https://github.com/Alaydriem/bedrock-voice-chat/wiki/Local-and-Self-Hosted-Worlds"
-->
