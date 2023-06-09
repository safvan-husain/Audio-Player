# audio_player

This is a simple audio player built with Flutter that allows you to play multiple audio files simultaneously. It utilizes the Provider package for state management and the audioplayers package for audio playback.

## Features

- Play multiple audio files simultaneously
- Pause and resume audio playback
- Display the duration and current position of each audio file

## Installation

1. Make sure you have Flutter installed on your machine. If not, follow the installation guide at [flutter.dev](https://flutter.dev/docs/get-started/install).

2. Clone this repository to your local machine using the following command:

   ```shell
   git clone https://github.com/safvan-husain/Audio-Player
   ```

3. Change your working directory to the cloned repository:

   ```shell
   cd audio-player
   ```

4. Fetch and download the dependencies by running the following command:

   ```shell
   flutter pub get
   ```

## Usage

1. Open the project in your preferred IDE or editor.

2. Locate the `lib` folder and navigate to `audio_list.dart`.

3. Modify the `audioFiles` list in `main.dart` to include the paths or URLs of the audio files you want to play. For example:

   ```dart
   List<String> audioPaths = [
      'audios/aaro.mp3',
      'audios/adam_john.mp3',
      'audios/bgm.mp3',
      // Add more audio file paths
    ];
   ```

   Make sure the audio files are accessible in your project.

4. Run the app on a simulator or physical device using the following command:

   ```shell
   flutter run
   ```

## Dependencies

The following packages are used in this project:

- [flutter](https://pub.dev/packages/flutter)
- [provider](https://pub.dev/packages/provider)
- [audioplayers](https://pub.dev/packages/audioplayers)
- [audio_video_progress_bar](https://pub.dev/packages/audio_video_progress_bar)
- [custom_navigation_bar](https://pub.dev/packages/custom_navigation_bar)
- [path](https://pub.dev/packages/path)

These packages will be automatically fetched and downloaded during the installation process.


