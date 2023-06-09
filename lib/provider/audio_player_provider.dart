import 'package:audio_player/utils/audio_name.dart';
import 'package:flutter/material.dart';

import '../services/audio_services.dart';

class AudioPlayerProvider extends ChangeNotifier {
  Map<String, AudioServices> audioPlayer = {};

  int length() {
    return audioPlayer.length;
  }

  void appenAudio(String audioPath) {
    String name = extractFileName(audioPath);
    if (!audioPlayer.containsKey(name)) {
      audioPlayer[name] = AudioServices(audioPath: audioPath);
      if (audioPlayer[name] != null) audioPlayer[name]!.play();
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
      audioPlayer.remove(name);
      notifyListeners();
    }
  }
}
