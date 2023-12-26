import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState {
  Locale locale = const Locale('en', 'US');
}

class LanguageController extends StateNotifier<LanguageState> {
  final SharedPreferences _prefs;

  LanguageController(this._prefs) : super(LanguageState());

  void setToFarsi(BuildContext context) async {
    state = LanguageState()..locale = const Locale('fa', 'AF');
   await context.setLocale(const Locale('fa', 'AF'));
   await _saveLocale('fa_AF');
  }

  void setToEnglish(BuildContext context) async {
    state = LanguageState()..locale = const Locale('en', 'US');
   await  context.setLocale(const Locale('en', 'US')) ;
  await  _saveLocale('en_US');
  }

  Future<void> _saveLocale(String localeKey) async {
    await _prefs.setString('appLocale', localeKey);
  }
}

final languageProvider =
StateNotifierProvider<LanguageController, LanguageState>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return LanguageController(prefs);
});
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Implement this to get SharedPreferences
});