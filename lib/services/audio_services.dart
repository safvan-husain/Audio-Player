// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:audioplayers/audioplayers.dart';

class AudioServices {
  String audioPath;

  AudioServices({
    required this.audioPath,
  }) {
    _set();
  }

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _set() async {
    await audioPlayer.setSource(AssetSource(audioPath));
  }

  void play() async {
    await audioPlayer.resume();
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void stop() async {
    await audioPlayer.stop();
  }

  AudioPlayer get player => audioPlayer;
}
