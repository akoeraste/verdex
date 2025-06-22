import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

/// An asset loader that fetches translations from a remote server.
///
/// This allows for dynamic updates to translations without needing to
/// release a new version of the app.
class RemoteTranslationLoader extends AssetLoader {
  const RemoteTranslationLoader();

  // The base URL for your translations API.
  // Replace this with your actual API endpoint.
  final String _baseUrl = 'https://your-api.com/translations';

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    try {
      // Construct the URL for the specific language.
      // e.g., https://your-api.com/translations/en.json
      final url = Uri.parse('$_baseUrl/${locale.languageCode}.json');
      
      // Make the network request to fetch the translations.
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response,
        // then parse the JSON.
        return json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        debugPrint('Failed to load translations for $locale from $url');
        return null;
      }
    } catch (e) {
      // If an error occurs during the request, print it to the console.
      debugPrint('Error loading translations for $locale: $e');
      return null;
    }
  }
} 