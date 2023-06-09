import 'package:flutter/material.dart';

import '../services/audio_services.dart';

class AudioPlayerProvider extends ChangeNotifier {
  Map<String, AudioServices> audioPlayer = {};

  int length() {
    return audioPlayer.length;
  }

  void appenAudio(String name, AudioServices audio) {
    audio.play();
    if (!audioPlayer.containsKey(name)) {
      audioPlayer[name] = AudioServices(audioPath: "/audio/$name.mp3");
      notifyListeners();
    }
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
      // audioPlayer[name]!.player.dispose();
      audioPlayer.remove(name);
      notifyListeners();
    }
  }
}
