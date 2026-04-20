import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  late Map<String, String> _localizedStrings;
Future<void> load() async {
  String jsonString =
      await rootBundle.loadString('assets/l10n/${locale.languageCode}.json');

  Map<String, dynamic> jsonMap = json.decode(jsonString);

  _localizedStrings =
      jsonMap.map((key, value) => MapEntry(key, value.toString()));
}

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'te'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
/// 🔥 Load saved language on app start
Future<void> loadSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('lang') ?? 'en';
  localeNotifier.value = Locale(langCode);
}

/// 🔥 Save language when changed
Future<void> setLocale(String langCode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lang', langCode);
  localeNotifier.value = Locale(langCode);
}