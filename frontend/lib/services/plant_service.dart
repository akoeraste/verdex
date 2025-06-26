import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_config.dart';
import 'package:intl/intl.dart';
import 'language_service.dart';
import 'package:collection/collection.dart';

class PlantService {
  static final PlantService _instance = PlantService._internal();
  factory PlantService() => _instance;
  PlantService._internal();

  static const String _cacheKey = 'cached_plants';
  static const String _lastFetchKey = 'last_fetch_time';
  static const Duration _cacheExpiry = Duration(hours: 1); // Cache for 1 hour

  Future<List<Map<String, dynamic>>> getAllPlants({
    bool forceRefresh = false,
  }) async {
    try {
      // Check if we have cached data and it's not expired
      if (!forceRefresh) {
        final cachedPlants = await loadCachedPlants();
        if (cachedPlants.isNotEmpty && await _isCacheValid()) {
          return cachedPlants;
        }
      }

      final url = '${ApiConfig.baseUrl}/plants/app/all';
      print('Calling API URL: $url');

      // Fetch from online database
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Headers: ${response.headers}');
      print(
        'API Response Body (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}',
      );

      if (response.statusCode == 200) {
        // Check if response is HTML (error page) instead of JSON
        if (response.body.trim().startsWith('<!doctype html>') ||
            response.body.trim().startsWith('<html')) {
          print(
            'ERROR: Received HTML instead of JSON. This indicates a routing or server issue.',
          );
          throw Exception(
            'Server returned HTML instead of JSON. Check API endpoint configuration.',
          );
        }

        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final List<dynamic> responseData = responseJson['data'] ?? [];

        print('Plants data length: ${responseData.length}');

        final plants =
            responseData.map((plant) => _formatPlantData(plant)).toList();

        // Cache the data
        await cachePlants(plants);

        return plants;
      } else {
        // If online fetch fails, try to return cached data
        final cachedPlants = await loadCachedPlants();
        if (cachedPlants.isNotEmpty) {
          return cachedPlants;
        }
        throw Exception(
          'Failed to load plants: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error in getAllPlants: $e');
      // If any error occurs, try to return cached data
      final cachedPlants = await loadCachedPlants();
      if (cachedPlants.isNotEmpty) {
        return cachedPlants;
      }
      throw Exception('Failed to load plants: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchPlants(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/plants/app/search?search=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final List<dynamic> responseData = responseJson['data'] ?? [];

        return responseData.map((plant) => _formatPlantData(plant)).toList();
      } else {
        throw Exception(
          'Failed to search plants: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to search plants: $e');
    }
  }

  Future<Map<String, dynamic>?> getPlantById(int id) async {
    // Try to get from cache first
    final cachedPlants = await loadCachedPlants();
    final plantFromCache = cachedPlants.firstWhereOrNull((p) => p['id'] == id);
    if (plantFromCache != null) {
      return _formatPlantData(plantFromCache);
    }
    final languageService = LanguageService();
    final langCode = languageService.effectiveLanguageCode;
    final urlWithLang = '${ApiConfig.baseUrl}/plants/$id?lang=$langCode';
    final urlWithoutLang = '${ApiConfig.baseUrl}/plants/$id';
    try {
      // Try with lang param first
      final response = await http.get(
        Uri.parse(urlWithLang),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 &&
          !response.body.trim().startsWith('<!doctype html>') &&
          !response.body.trim().startsWith('<html')) {
        final data = jsonDecode(response.body)['data'];
        return data != null ? _formatPlantData(data) : null;
      } else {
        // Fallback: try without lang param
        final fallbackResponse = await http.get(
          Uri.parse(urlWithoutLang),
          headers: {'Content-Type': 'application/json'},
        );
        if (fallbackResponse.statusCode == 200 &&
            !fallbackResponse.body.trim().startsWith('<!doctype html>') &&
            !fallbackResponse.body.trim().startsWith('<html')) {
          final data = jsonDecode(fallbackResponse.body)['data'];
          return data != null ? _formatPlantData(data) : null;
        } else {
          // If backend fails or returns HTML, try cache again
          final cachedPlantsRetry = await loadCachedPlants();
          final plantRetry = cachedPlantsRetry.firstWhereOrNull(
            (p) => p['id'] == id,
          );
          if (plantRetry != null) {
            return _formatPlantData(plantRetry);
          }
          throw Exception(
            'Failed to load plant: Backend returned HTML or error, and plant not found in cache.',
          );
        }
      }
    } catch (e) {
      // On any error, try cache again
      final cachedPlantsRetry = await loadCachedPlants();
      final plantRetry = cachedPlantsRetry.firstWhereOrNull(
        (p) => p['id'] == id,
      );
      if (plantRetry != null) {
        return _formatPlantData(plantRetry);
      }
      throw Exception('Failed to load plant: $e');
    }
  }

  String _getFullImageUrl(String? relativeUrl) {
    if (relativeUrl == null || relativeUrl.isEmpty) {
      return '';
    }

    // If it's already a full URL, return as is
    if (relativeUrl.startsWith('http://') ||
        relativeUrl.startsWith('https://')) {
      return relativeUrl;
    }

    // Convert relative URL to absolute URL
    final baseUrl = ApiConfig.baseUrl.replaceFirst('/api', '');
    final fullUrl = '$baseUrl$relativeUrl';
    print('Image URL conversion: $relativeUrl -> $fullUrl');
    return fullUrl;
  }

  String _getFullAudioUrl(String? relativeUrl) {
    if (relativeUrl == null || relativeUrl.isEmpty) {
      return '';
    }

    if (relativeUrl.startsWith('http://') ||
        relativeUrl.startsWith('https://')) {
      return relativeUrl;
    }

    final baseUrl = ApiConfig.baseUrl.replaceFirst('/api', '');
    return '$baseUrl$relativeUrl';
  }

  Map<String, dynamic> _formatPlantData(Map<String, dynamic> plant) {
    try {
      print('Formatting plant: ${plant['scientific_name']}');

      final translations = (plant['translations'] as List<dynamic>?) ?? [];
      print('Translations found: ${translations.length}');

      final languageService = LanguageService();
      final effectiveLang = languageService.effectiveLanguageCode;
      final majorLang = languageService.majorLanguageCode;

      final translation =
          translations.firstWhere(
            (t) => t['language_code'] == effectiveLang,
            orElse:
                () => translations.firstWhere(
                  (t) => t['language_code'] == majorLang,
                  orElse:
                      () => translations.firstWhere(
                        (t) => t['language_code'] == 'en',
                        orElse: () => {},
                      ),
                ),
          ) ??
          {};

      print('Selected translation for language "$effectiveLang": $translation');

      // Get the first image URL and convert to full URL
      String imageUrl = '';
      if (plant['image_urls'] != null &&
          (plant['image_urls'] as List).isNotEmpty) {
        final relativeUrl = plant['image_urls'][0];
        imageUrl = _getFullImageUrl(relativeUrl);
        print('Image URL conversion: $relativeUrl -> $imageUrl');
      }

      final formattedPlant = {
        'id': plant['id'],
        'scientific_name': plant['scientific_name'] ?? '',
        'name': translation['common_name'] ?? plant['scientific_name'] ?? '',
        'description': translation['description'] ?? '',
        'family': plant['family'] ?? '',
        'category': plant['plant_category']?['name'] ?? '',
        'genus': plant['genus'] ?? '',
        'species': plant['species'] ?? '',
        'toxicity_level': plant['toxicity_level'] ?? '',
        'uses': translation['uses'] ?? '',
        'tags': [], // Tags not implemented in backend yet
        'image_url': imageUrl,
        'audio_url': _getFullAudioUrl(translation['audio_url']),
        'created_at': plant['created_at'],
        'updated_at': plant['updated_at'],
        'translations': translations,
      };

      print('Formatted plant: $formattedPlant');
      print('Final image URL: ${formattedPlant['image_url']}');
      return formattedPlant;
    } catch (e) {
      print('Error formatting plant: $e');
      print('Plant data: $plant');
      rethrow;
    }
  }

  Future<void> cachePlants(List<Map<String, dynamic>> plants) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(plants));
    await prefs.setInt(_lastFetchKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Map<String, dynamic>>> loadCachedPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      final List<dynamic> data = jsonDecode(cachedData);
      return data.map((plant) => Map<String, dynamic>.from(plant)).toList();
    }
    return [];
  }

  Future<bool> _isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFetch = prefs.getInt(_lastFetchKey);
    if (lastFetch == null) return false;

    final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetch);
    final now = DateTime.now();
    return now.difference(lastFetchTime) < _cacheExpiry;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_lastFetchKey);
  }

  Future<void> refreshCache() async {
    await getAllPlants(forceRefresh: true);
  }

  Future<Map<String, dynamic>?> identifyPlant(File image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // Handle not logged in
      return null;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/identify'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      // For now, return dummy data without making a real request
      await Future.delayed(const Duration(seconds: 2));
      return {
        'name': 'Tomato',
        'description':
            'The tomato is the edible berry of the plant Solanum lycopersicum.',
        'family': 'Solanaceae',
        'category': 'Fruit',
        'uses': 'Culinary',
        'tags': ['edible', 'vegetable'],
        'image_url': 'https://via.placeholder.com/300',
      };
      /*
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = jsonDecode(responseData);
        return decodedData;
      }
      */
    } catch (e) {
      // Handle exceptions
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // Not logged in
      return [];
    }

    /*
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/plants'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
    */

    // Returning dummy data for now
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'id': 1,
        'name': 'Tomato',
        'description':
            'The tomato is the edible berry of the plant Solanum lycopersicum.',
        'family': 'Solanaceae',
        'category': 'Fruit',
        'uses': 'Culinary',
        'tags': ['edible', 'vegetable'],
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Bright_red_tomato_and_cross_section02.jpg/800px-Bright_red_tomato_and_cross_section02.jpg',
        'created_at': '2023-10-26T10:00:00.000000Z',
      },
      {
        'id': 2,
        'name': 'Basil',
        'description': 'A culinary herb of the family Lamiaceae.',
        'family': 'Lamiaceae',
        'category': 'Plant',
        'uses': 'Culinary, Medicinal',
        'tags': ['herb', 'green'],
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Basil-pesto.jpg/800px-Basil-pesto.jpg',
        'created_at': '2023-10-25T11:00:00.000000Z',
      },
      {
        'id': 3,
        'name': 'Carrot',
        'description': 'A root vegetable, typically orange in color.',
        'family': 'Apiaceae',
        'category': 'Plant',
        'uses': 'Culinary',
        'tags': ['root', 'vegetable'],
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Karotten.jpg/800px-Karotten.jpg',
        'created_at': '2023-10-24T12:00:00.000000Z',
      },
    ];
  }

  // Test if an image URL is accessible
  Future<bool> testImageUrl(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      print('Image URL test: $imageUrl -> Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Image URL test failed: $imageUrl -> Error: $e');
      return false;
    }
  }

  // Get a fallback image URL if the original fails
  String getFallbackImageUrl(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) {
      return 'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=Plant';
    }

    // For now, return a placeholder image
    return 'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=Plant';
  }

  // Test method to verify API connection
  Future<void> testApiConnection() async {
    try {
      final url = '${ApiConfig.baseUrl}/plants/app/all';
      print('Testing API connection to: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Test Response Status: ${response.statusCode}');
      print('Test Response Content-Type: ${response.headers['content-type']}');
      print(
        'Test Response Body (first 200 chars): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
      );

      if (response.statusCode == 200) {
        print('✅ API connection successful');
      } else {
        print('❌ API connection failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API connection error: $e');
    }
  }

  // Force refresh - clear cache and fetch fresh data
  Future<List<Map<String, dynamic>>> forceRefreshPlants() async {
    print('Force refreshing plants - clearing cache');
    await _clearCache();
    return getAllPlants(forceRefresh: true);
  }

  // Clear all cached data
  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_plants');
    await prefs.remove('plants_cache_timestamp');
    print('Cache cleared');
  }
}
