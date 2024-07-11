import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  static String _currentThemeMode = 'Light Theme';
  static ThemeService instance = ThemeService();

  String get currentThemeMode => _currentThemeMode;

  void toggleTheme() {
    if (_currentThemeMode == 'Light Theme') {
      _currentThemeMode = 'Dark Theme';
    } else {
      _currentThemeMode = 'Light Theme';
    }
    notifyListeners();
  }
}
