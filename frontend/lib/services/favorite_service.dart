import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:verdex/constants/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  Future<List<int>> getFavorites() async {
    final token = await _getToken();
    if (token == null) {
      // Not logged in, return empty favorites
      return [];
    }
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/favorites'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<int>.from(data['data']);
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addFavorite(int plantId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/favorites'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'plant_id': plantId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      print(
        'addFavorite failed: status=${response.statusCode}, body=${response.body}',
      );
      throw Exception('Failed to add favorite');
    }
  }

  Future<void> removeFavorite(int plantId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/favorites/$plantId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite');
    }
  }

  Future<bool> isFavorite(int plantId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/favorites/$plantId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['is_favorite'] == true;
    } else {
      throw Exception('Failed to check favorite');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
