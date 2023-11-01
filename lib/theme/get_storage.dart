import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

//cubit is using due to the need of changing playlist picture.
class FastStorage extends Cubit<bool> {
  static final _box = GetStorage();
  static const _key = 'isThemeMode';
  static const _guideKey = 'isGuideShown';

  FastStorage() : super(_box.read(_key) ?? false);

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  bool get shouldShowGuide => _loadGuideFromBox();

  bool _loadGuideFromBox() => _box.read<bool>(_guideKey) ?? true;

  void showGuide() {
    _box.write(_guideKey, true);
  }

  void guideShown() {
    _box.write(_guideKey, false);
  }
}
