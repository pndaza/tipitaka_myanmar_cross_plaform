import 'package:flutter/material.dart';

class ThemeController {
  final _themeMode = ValueNotifier(ThemeMode.light);
  ValueNotifier<ThemeMode> get themeMode => _themeMode;

  void toggle() {
    if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.light;
    }
  }
}
