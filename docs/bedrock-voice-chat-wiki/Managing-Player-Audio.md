As you use Bedrock Voice Chat, both nearby players and players in your dedicated audio group

![Bedrock Voice Chat Main PAge](https://private-user-images.githubusercontent.com/630969/491993083-2e468dff-1843-45d5-8232-672818093d4a.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjEwODcyODAsIm5iZiI6MTc2MTA4Njk4MCwicGF0aCI6Ii82MzA5NjkvNDkxOTkzMDgzLTJlNDY4ZGZmLTE4NDMtNDVkNS04MjMyLTY3MjgxODA5M2Q0YS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUxMDIxJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MTAyMVQyMjQ5NDBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1iN2ViZGE4YzIwMjI1M2ZlOWM3MDFiOGFlM2E1MDE1NWNkOWZjZjk3M2YyOGNiNTJiOTc1NGRlZjU5NjMzZjhjJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.EGMvqJFMr5OqxpdXgV4cA31SL7O9RlpQb9-OVH8NX2U)

## Proximity Audio

By default, you will only be able to hear players that are near you. BVC simulates full spatial audio by remapping the mono input from a given player into 3D coordinate space, based upon your orientation and position, and the orientation and position of the person your speaking to in-game.

By default you will hear all players within 0-24 blocks at full volume, with volume decreasing to 0dB between 24 and 48 blocks away. Outside of this range, you will not be able to hear any players.

## Group Audio

> For more information, see the groups section

While in group mode, you will be able to hear all players in your group at normal volume, and without any spatial audio. Groups are a way to ensure constant communication with your party, but are _not_ exclusive. You will still be able to hear nearby players, and speak to players that come within your proximity range.

## Muting and Deafening Yourself

On the bottom left of the secondary sidebar are individual player mute and deafen controls. The mute button will stop transmitting any audio from your system to the server.

The deafen button will mute all incoming audio

## Muting, Deafening, and Adjusting the Audio of Others Players

Individual player audio can be adjusted per-player using the controls in the player tile. Individual player audio can be muted entirely or changed from 0 to 150% of their given input. When adjusting player volume you should adjust it within the 0-24 block range, as this will be the default volume before any gain attenuation is performed on that player.

> Note that muting a player does not prevent them from hearing you.

<!-- metadata
title: "Managing Player Audio in BVC"
topic: audio
tags: rag
-->

