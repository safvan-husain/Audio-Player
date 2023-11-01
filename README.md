# Audio Player App Documentation

## Overview

The Audio Player app is a versatile audio tool designed to allow users to download audio content from YouTube in MP3 format and enjoy a seamless listening experience.

## Features

- **YouTube Audio Download:** Easily convert YouTube videos to MP3 format by sharing them with the app.
- **Notification Panel Controls:** Manage playback with convenience via the notification panel.
- **Waveform Visualization:** Visualize audio tracks with a waveform representation.
- **Track Information:** Display track duration and current playback position.
- **Favorites & Playlists:** Organize your music by adding tracks to favorites and playlists.
- **Light & Dark Modes:** Choose your preferred visual theme.

## Installation

1. Download the Audio Player app from [Google Drive](https://drive.google.com/drive/folders/12eCZN5g8HDahnbhAMPUzezFydkoy48JD?usp=share_link).

## Usage

1. Open the YouTube app and share the video you wish to convert to MP3 with the Audio Player app.
2. The app will automatically initiate the cloud-based conversion process.
3. After completion, tap the "Download from Web" button.
4. This will open your default browser to a webpage.
5. Click the "Download" button on the webpage.
6. If the download is not an MP3, cancel it.
7. Open the app and refresh by swiping down if the downloaded MP3 is not visible.

## App Architecture

- **/lib**

  - **/bloc**: This section contains the majority of the application's business logic.
  - **/database**:
    - `class MyDataBase`: This class contain the SQLite `db` object, handles its initialization, and manages table creation.
    - `class DataBaseService`: A singleton class that provides methods for data manipulation throughout the application.
    - Mixins `PlayListDataBase` and `TrackDataBase`: These mixins offer specific methods related to playlists and tracks, which is utilized through `DataBaseService`.
  - **/services**:
    1. [Audio Download Service](#audio-download-service)
    2. [Audio Player Service](#audio-player-service)

## Key Features Implementation

### Audio Download Service

This service employs the following API: `'https://youtube-mp3-download1.p.rapidapi.com/'`. It is used to convert YouTube videos to MP3 format and, upon success, provides a URL to a web page containing the MP3 file. Efforts were made to automate this process via web scraping, but the download link remains unexposed in the HTML.

### Audio Player Service

The audio player service utilizes the Dart packages `audioplayers` and `audio services`. A critical component is the `class AudioHandler`, an extension of `BaseHandler` from the `audio service` package, designed for controlling audio playback from the notification panel. Within its constructor, `player.onPlayerStateChanged.map(_transformEvent).pipe(playbackState)` is employed to ensure that changes in the audio player state are reflected in the control panel.

### WaveForm Visualization

To generate waveform data from audio file project utlize Dart packages `just waveform`.and `CustomPaint` used to visualize the data.
