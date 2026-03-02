Bedrock Voice Chat provides several customizable settings to enhance your experience. To access the settings, use the gear icon in the bottom left of the BVC menu to access them.

## Audio Settings
The Audio settings page allows you to modify your individual audio settings, including your input and output device, and any audio modifications

<img alt="Screenshot 2025-10-21 203054" src="https://github.com/user-attachments/assets/57d49ffb-5411-4a6d-a834-89eb14122a47" />

### Audio Input and Output Device

By default, BVC will use your platform's default communication device and speaker, however using the provided dropdowns BVC can be configured to capture any specific microphone and output to any dedicated audio device.

#### Windows
On Windows, both the default Windows audio drivers and ASIO drivers are supported.

> All input audio is mixed to mono, regardless of the origin device

### Noise Suppression

#### Built-in Noise Gate

If you are not using a VST chain or any system noise filtering, BVC provides a built-in noise-gate that functions identically to OBS' noise-gate filter in audio settings. The defaults values provide a "good enough for most" set of settings to eliminate any background noise and hum from you ambient environment, such as fans, mouse clicks, and keyboard clicking. The adjustment dials can be used to fine tune the noise gate

#### Deep Filter Net

BVC also comes with a "AI" audio filtering model that can help filter out unwanted noise as well.

> This feature is currently in Alpha, and requires access to special build parameters to access.

## Recording Settings

Audio recordings enable you to download previously recorded audio settings, and export individual players to dedicated WAV or MP3 audio files

<img alt="Screenshot 2025-10-21 203102" src="https://github.com/user-attachments/assets/a932edf7-38de-4559-9991-7b580ef1eaaa" />

> This feature is currently in Alpha, and requires access to a special build of BVC to access.

<!-- metadata
title: "BVC Client Settings"
topic: settings
tags: rag
-->
