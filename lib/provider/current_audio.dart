import 'package:flutter/material.dart';

class CurrentAudioProvider extends ChangeNotifier {
  String _audioPath = '';
  String get audioPath => _audioPath;
  void changeAudio(String audioPath) {
    _audioPath = audioPath;
    notifyListeners();
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void setPlay(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }
}
