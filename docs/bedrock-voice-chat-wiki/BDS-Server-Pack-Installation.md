Bedrock Voice Chat requires a server-side behavior pack in order to determine player positioning for proximity chat. Server operators must have this pack installed and running before you can connect to a Bedrock Voice Chat Instance.

1. Download the latest behavior pack from the Github Releases page. This will be provided as either a zip file or an mcpack

2. Upload the pack to your BDS Server instance to the _root_ behavior_packs directory. There is not need to extract this.

> Do not upload the pack to your worlds folder, as you may inadvertently expose BVC Server endpoint, and API keys in any public downloads.

3. If you are _not_ using a pre-generated pack that has your access token and server address embedded into the pack, add the following to your `config/default/variables.json` file on the server.

```
    {
        "bvc_access_token": "<YOUR_TOKEN_DEFINED_FROM_HCL_HERE>",
        "bvc_server": "https://YOUR_BVC_SERVER_FQDN",
        "bvc_debug": false
    }
```

4. Update your config/default/permissions.json to have the following:

```
{
    "allowed_modules": [
        "@minecraft/server-gametest",
        "@minecraft/server",
        "@minecraft/server-ui",
        "@minecraft/server-admin",
        "@minecraft/server-editor",
        "@minecraft/server-net"
    ]
}
```

5. Ensure Beta APIs are enabled for your world.
6. Update your world behavior packs file to enable the addon. The UUID is: `6fb24263-357a-407c-aebe-681f50b2de50` and the version is `[0, 0, 3]`
7. Start BDS Server.

----

### Troubleshooting

1. Set `content-log-console-output-enabled=true` in your server.properties file to see the connection event data. If you don't see `[BVC] Connecting to: <host>` then BDS isn't relaying player data to the server.
2. Make sure you whitelist your players first in BVC Server so they can login to the app.
3. BVC will only send player data if there's two or more people online as a bandwidth saving measure. You can override this by setting `bvc_debug` to `true` instead then restarting your server.
4. Make sure `/api/config` is returning a valid JSON response to validate your server is up
5. Query GET /api/position with your Token as `X-MC-Access-Token` to peek at player positions on the server. If this is empty then BDS isn't relaying position data.

<!-- metadata
title: "BDS Server Behavior Pack Installation"
topic: bds-installation
tags: rag
-->

