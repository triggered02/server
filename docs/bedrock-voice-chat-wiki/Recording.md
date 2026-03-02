
> NOTE: This is a Windows only feature. Mobile devices do not support recording due to processor and disk limitations. If you want to record a session, please be sure to do so on a desktop device.

Using the "REC" button on the bottom of the sub-sidebar you can record all of your chats using Bedrock Voice Chat for export later! This is useful if you want to manually remix player audio and don't want to use OBS as your primary recorder.

Simply press the REC button to start a recording - after which the recording light will turn red.

<img  alt="Screenshot 2025-10-21 204657" src="https://github.com/user-attachments/assets/7df9c6e8-8da3-40a1-aa84-be48193694f3" />

Recorded sessions capture both position data and group data. Once your session is done, simply stop the recording, then head to the settings / recordings page to manage the recording itself, including exporting the individual audio tracks out to dedicated audio files.

## Recordings Tab
<img width="1336" height="801" alt="Screenshot 2025-11-24 225353" src="https://github.com/user-attachments/assets/d039af53-7db8-40cd-9d51-5333cb5eb6b5" />

The recordings page enables you view all recent recordings, view all participants, delete recordings, and export them as bwav (.wav) files to disk. By default, exporting recording will export all participants as separate files. Expanding the dropdown to view all participants will let you select which participants you want to export as part of the recording session.

Recordings can easily be deleted from this menu as well.

Once a recording is exported, it will open the folder where your records are stored for use in your editor. By default this is located at the following path:

```
%localappdata%/com.alaydriem.bvc.client/recordings/<session_uuid>/renders
```

Wav files can be _particularly_ large since bwav data is effectively raw PCM. Be sure to clean up old files, and break up recordings into smaller sessions to avoid render disk fill. A 30s wav file can easily take up between 5-15 Mb of data, per player. Meaning a 2 hour session with 6 participants can
render up to 7-21 GB of Wav files.

Additional renderers will be added soon to assist with PCM size.

<!-- metadata
title: "Recording Voice Chat Sessions"
topic: recording
tags: rag
-->
