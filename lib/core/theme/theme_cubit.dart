import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'app_theme_mode';
  late SharedPreferences _prefs;

  /// Dark mode is forced platform-wide: the app always starts in
  /// [ThemeMode.dark] and every setter below re-emits dark.
  ThemeCubit() : super(ThemeMode.dark);

  /// Initialize SharedPreferences — call this before using the cubit.
  /// The saved preference is ignored and overwritten with `dark`.
  Future<void> initialize(SharedPreferences prefs) async {
    _prefs = prefs;
    emit(ThemeMode.dark);
    await _saveTheme(ThemeMode.dark);
  }

  /// No-op kept for API compatibility — dark mode is forced.
  Future<void> toggleTheme() async {
    emit(ThemeMode.dark);
    await _saveTheme(ThemeMode.dark);
  }

  /// No-op kept for API compatibility — dark mode is forced.
  Future<void> setLight() async {
    emit(ThemeMode.dark);
    await _saveTheme(ThemeMode.dark);
  }

  Future<void> setDark() async {
    emit(ThemeMode.dark);
    await _saveTheme(ThemeMode.dark);
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveTheme(ThemeMode theme) async {
    final themeString = theme == ThemeMode.dark ? 'dark' : 'light';
    await _prefs.setString(_themeKey, themeString);
  }

  bool get isDark => state == ThemeMode.dark;
}
