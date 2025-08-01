import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language {
  final String code;
  final String name;
  final bool isMajor;
  final List<Language> minorLanguages;

  Language({
    required this.code,
    required this.name,
    this.isMajor = false,
    this.minorLanguages = const [],
  });
}

class LanguageService with ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  static const String _majorLanguageKey = 'major_language_code';
  static const String _minorLanguageKey = 'minor_language_code';

  String _majorLanguageCode = 'en';
  String? _minorLanguageCode;
  bool _isLoaded = false;

  String get majorLanguageCode => _majorLanguageCode;
  String? get minorLanguageCode => _minorLanguageCode;
  String get effectiveLanguageCode => _minorLanguageCode ?? _majorLanguageCode;

  final List<Language> _availableLanguages = [
    Language(
      code: 'en',
      name: 'English',
      isMajor: true,
      minorLanguages: [
        Language(code: 'en-PG', name: 'Pidgin'),
        Language(code: 'bm', name: 'Bambili'), // changed from 'en-BL' to 'bm'
      ],
    ),
    Language(
      code: 'fr',
      name: 'French',
      isMajor: true,
      minorLanguages: [],
    ),
    Language(
      code: 'gm',
      name: 'Ngombale',
      isMajor: false,
      minorLanguages: [],
    ),
  ];

  List<Language> get availableLanguages => _availableLanguages;

  Future<void> loadSavedLanguage() async {
    if (_isLoaded) return; // Prevent multiple loads

    final prefs = await SharedPreferences.getInstance();
    _majorLanguageCode = prefs.getString(_majorLanguageKey) ?? 'en';
    _minorLanguageCode = prefs.getString(_minorLanguageKey);
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setLanguage(String majorCode, {String? minorCode}) async {
    _majorLanguageCode = majorCode;
    _minorLanguageCode = minorCode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_majorLanguageKey, majorCode);
    if (minorCode != null) {
      await prefs.setString(_minorLanguageKey, minorCode);
    } else {
      await prefs.remove(_minorLanguageKey);
    }
    notifyListeners();
  }
}
