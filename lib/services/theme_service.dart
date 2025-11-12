import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeService() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString('theme_mode');
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.toString() == 'ThemeMode.$themeString',
      orElse: () => ThemeMode.system,
    );
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString().split('.')[1]);
  }
}
