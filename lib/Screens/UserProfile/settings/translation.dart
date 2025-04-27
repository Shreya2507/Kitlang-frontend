import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:redux/redux.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();

  factory TranslationService() => _instance;

  TranslationService._internal();

  String _currentLanguage = 'en';
  Map<String, String> _translations = {};

  // Caching loaded languages to prevent redundant loading
  bool _isLanguageLoaded = false;

  Future<void> setLanguage(String languageCode) async {
    if (_currentLanguage == languageCode && _isLanguageLoaded) return;

    _currentLanguage = languageCode;
    _isLanguageLoaded = false; // Reset the loaded state before loading

    try {
      final jsonString = await rootBundle.loadString('assets/languages/translations.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Load the language if it exists in the JSON file
      if (jsonMap.containsKey(languageCode)) {
        _translations = Map<String, String>.from(jsonMap[languageCode]);
      } else {
        // If the language is not found, fallback to English
        _translations = Map<String, String>.from(jsonMap['en']);
      }

      _isLanguageLoaded = true;
      print("[TranslationService] Loaded language: $_currentLanguage");
    } catch (e) {
      print("[TranslationService] Error loading translations for $_currentLanguage: $e");
      _translations = {}; // Reset translations in case of an error
      _isLanguageLoaded = false;
    }
  }

  String translate(String key) {
    final translation = _translations[key] ?? key;
    print("[translate] $key -> $translation");
    return translation;
  }

  String get currentLanguage => _currentLanguage;
}
