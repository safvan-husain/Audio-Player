import 'package:flutter/material.dart';

class FavouriteAudioProvider extends ChangeNotifier {
  List<String> audioPaths = [];

  void addTOFavourite(String audioPath) {
    audioPaths.add(audioPath);
    notifyListeners();
  }

  void removeFromFavourite(String audioPath) {
    audioPaths.remove(audioPath);
    notifyListeners();
  }

  bool isFavourite(String audioPath) {
    if (audioPaths.contains(audioPath)) return true;
    return false;
  }
}
