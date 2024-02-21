import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  ThemeMode _currentThemeMode = ThemeMode.light;
  late SharedPreferences _preferences;

  ThemeMode get currentThemeMode => _currentThemeMode;

  Future<void> initialize() async {
    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    await loadSavedTheme();
  }

  Future<void> loadSavedTheme() async {
    final ThemeMode savedTheme =
        ThemeMode.values[_preferences.getInt('themeMode') ?? 0];
    setThemeMode(savedTheme);
  }

  void setThemeMode(ThemeMode themeMode) {
    if (_currentThemeMode != themeMode) {
      _currentThemeMode = themeMode;
      _preferences.setInt('themeMode', themeMode.index);
      notifyListeners();
    }
  }
}

final themeModelProvider = ChangeNotifierProvider<ThemeModel>((ref) {
  return ThemeModel();
});
