import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/audio_services.dart';

class AudioPlayerProvider extends ChangeNotifier {
  Map<String, AudioServices> audioPlayer = {};
  bool isEmpty() {
    if (audioPlayer.isEmpty) {
      return false;
    }
    return true;
  }

  void appenAudio(String name, String audioPath) {
    log(audioPlayer.length.toString());
    AudioServices audio = AudioServices(audioPath: audioPath);
    audio.play();
    audioPlayer[name] = audio;
    notifyListeners();
  }

  AudioServices? getAudio(String name) {
    if (audioPlayer.containsKey(name)) {
      return audioPlayer[name];
    }
    return null;
  }

  void stopAudio(String name) {
    if (audioPlayer.containsKey(name)) {
      audioPlayer[name]!.stop();
      audioPlayer.remove(name);
      notifyListeners();
    }
  }
}
