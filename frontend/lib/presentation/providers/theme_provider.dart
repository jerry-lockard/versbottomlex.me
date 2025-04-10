import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/logger.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;
  static const String _themeModeKey = 'themeMode';

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider(this._themeMode) {
    AppLogger.d('Theme initialized: ${_themeMode.toString()}');
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    // Save to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode == ThemeMode.light ? 'light' : 'dark');
      AppLogger.d('Theme saved: ${mode.toString()}');
    } catch (e) {
      AppLogger.e('Failed to save theme preference: $e');
    }
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}
