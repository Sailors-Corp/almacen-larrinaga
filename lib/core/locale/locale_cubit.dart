import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale?> {
  static const String localeKey = 'app_locale_code';

  /// Spanish is forced platform-wide: the app always resolves to [es] and
  /// every setter below is pinned to it, whatever the device or channel says.
  static const String forcedLanguageCode = 'es';

  late SharedPreferences _prefs;

  LocaleCubit() : super(const Locale(forcedLanguageCode));

  Future<void> initialize(SharedPreferences prefs) async {
    _prefs = prefs;
    // Persist the forced locale so GraphQL Accept-Language and the channel
    // bootstrap (which only writes when no value is saved) also use Spanish.
    await _prefs.setString(localeKey, forcedLanguageCode);
    emit(const Locale(forcedLanguageCode));
  }

  Future<void> setLocale(String languageCode) async {
    // Forced: ignore any other language request.
    emit(const Locale(forcedLanguageCode));
    await _prefs.setString(localeKey, forcedLanguageCode);
  }

  Future<void> clearLocale() async {
    // Forced: clearing is a no-op that re-asserts Spanish.
    emit(const Locale(forcedLanguageCode));
    await _prefs.setString(localeKey, forcedLanguageCode);
  }
}
