// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

class AudioServices {
  String audioPath;
  bool isLocal;

  AudioServices({
    required this.audioPath,
    this.isLocal = false,
  }) {
    _set();
  }

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _set() async {
    await player.setSource(DeviceFileSource(audioPath));
  }

  void play() async {
    try {
      await audioPlayer.resume();
      log('should be playing.');
    } catch (e) {
      log(e.toString());
    }
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void stop() async {
    await audioPlayer.stop();
  }

  bool isPlaying() {
    PlayerState current = PlayerState.paused;
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      current = s;
    });
    if (current == PlayerState.playing) return true;
    return false;
  }

  AudioPlayer get player => audioPlayer;
}
