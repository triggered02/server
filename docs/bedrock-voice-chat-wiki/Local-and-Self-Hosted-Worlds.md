**No, Bedrock Voice Chat does not work on locally hosted worlds, single player worlds, or LAN worlds.** This includes any world where one player hosts the game from their own device and other players join them — sometimes called a "self-hosted world" or a world where "the host must be online for friends to join."

BVC requires a Bedrock Dedicated Server (BDS) or a Java Dedicated Server running the appropriate behavior pack or mod. It cannot run on worlds hosted directly from the Minecraft game client.

------

## Why doesn't it work?

BVC needs a server-side addon (behavior pack or mod) installed on your Minecraft server. This addon sends player positioning data to the BVC Server, which is what makes proximity voice chat possible.

When you host a world locally from your game client (whether on PC, console, or mobile), there is no way to install server-side addons. The Minecraft game client does not support the `@minecraft/server-net` API that BVC relies on to transmit player data.

This is the same fundamental limitation that prevents BVC from working on Realms and single player worlds.

------

## What do I need instead?

To use Bedrock Voice Chat, you need:

1. A **Bedrock Dedicated Server (BDS)** or a **Java server** (with Fabric) — not a locally hosted world
2. The **BVC Server** running on a dedicated machine (VPS, your own hardware, etc.)
3. The **BVC Client** app installed on each player's device

See the [BVC Server Installation Guide](https://github.com/Alaydriem/bedrock-voice-chat/wiki/BVC-Server-Installation) for setup instructions.

------

## Will this be supported in the future?

Support for local and multiplayer worlds is something we want to solve. If you'd like to help make this happen, consider supporting Bedrock Voice Chat: https://discord.com/channels/1158951318166183936/1466979335255752899

Sponsors and Supporters will be the first to get access to new features. Your support enables me to dedicate time to working on solving this problem for all of us. : )

<!-- metadata
title: "Does Bedrock Voice Chat work on locally hosted, self-hosted, or LAN worlds?"
topic: local-worlds
tags: rag
see_also:
  - label: "Realms Support"
    url: "https://github.com/Alaydriem/bedrock-voice-chat/wiki/Realms-and-Multiplayer-Worlds"
  - label: "BVC Server Installation Guide"
    url: "https://github.com/Alaydriem/bedrock-voice-chat/wiki/BVC-Server-Installation"
  - label: "FAQ Discussion"
    url: "https://discord.com/channels/1158951318166183936/1466980955876098141"
-->
