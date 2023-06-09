import 'package:flutter/material.dart';

//page Index for navigation
class CurrentIndexProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
