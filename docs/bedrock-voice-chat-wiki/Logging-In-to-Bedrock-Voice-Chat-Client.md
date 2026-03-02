Bedrock Voice Chat authenticates you against your Xbox (Microsoft) / or your Hytale account, based upon the game to validate your identity and help secure any messages between both you and other players.

---

## First Time Logging In

If this is your _first_ time connecting to a BVC server, make sure you _first_ connect to the BDS or Hytale server instance. BVC utilizes BDS' allowlist.json users to determine who has access, and requires you to initially connect to the server to broadcast this information.

Server operators can pre-whitelist players by using the following command:

```
bedrock-voice-chat-server user add --player test --game hytale|minecraft
```

## Signing In

![BVC Login Window](https://private-user-images.githubusercontent.com/630969/447695899-53c7eb6c-da1e-4f4c-bb0e-6ed943f34fe2.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjEwODcyODAsIm5iZiI6MTc2MTA4Njk4MCwicGF0aCI6Ii82MzA5NjkvNDQ3Njk1ODk5LTUzYzdlYjZjLWRhMWUtNGY0Yy1iYjBlLTZlZDk0M2YzNGZlMi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUxMDIxJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MTAyMVQyMjQ5NDBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1lNzc0ZWZiOTlhZjM4NTNjZmQ5NTljYzE5NTVkNDU0YzJlODY4MGYxYWUzNTdmZjhhMTRlMTY3ODAwMGU5ZWM2JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.bFh_1wEZrLN7HxYyMf8EhtNHbcnOqPSzUoEvEwN3P-M)

Bedrock Voice Chat operates similar to Discord, in that you may have access to multiple servers. All servers use your same Xbox identity, but have different endpoints. Your server operator should provide you with the domain to connect to. This value must include https:// and the fully qualified domain name. For example:

```
https://example.alaydriem.bedrockvc.stream
```

You will be redirected to a Microsoft sign in page. Login with your Microsoft account associated to your Xbox account you will be playing on the server as. After you login, you will be redirected back to BVC. This process may take a moment to validate the single-sign on request, connect to your server, and perform some initial setup tasks.

Once you are signed in, you will be directed to the dashboard page -- from here -- put in your headphones, and play minecraft!

![BVC Dashboard](https://private-user-images.githubusercontent.com/630969/447696127-1a3d992d-d616-483d-a554-a90e8e15d65b.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjEwODcyODAsIm5iZiI6MTc2MTA4Njk4MCwicGF0aCI6Ii82MzA5NjkvNDQ3Njk2MTI3LTFhM2Q5OTJkLWQ2MTYtNDgzZC1hNTU0LWE5MGU4ZTE1ZDY1Yi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUxMDIxJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MTAyMVQyMjQ5NDBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT00YTRhNDRiNTU4NWM2OWZmN2E3N2Q0YmMxOWY5YzNlMDY5M2U2OGRhZjFmNDVlMTAyNmEzYWUwZDUyMGY1NzZkJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.HgX-kNVZa-n3UAEIoXs8H-xjrFNm9sDRkw8Srz8WEtM)

<!-- metadata
title: "Logging In to Bedrock Voice Chat Client"
topic: login
tags: rag
-->
