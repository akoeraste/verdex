import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteService {
  static const _favoritesKey = 'favorites';

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString(_favoritesKey);
    if (favoritesString != null) {
      final List<dynamic> favoritesList = jsonDecode(favoritesString);
      return favoritesList.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> addFavorite(Map<String, dynamic> plantData) async {
    final favorites = await getFavorites();
    if (!favorites.any((plant) => plant['name'] == plantData['name'])) {
      favorites.add(plantData);
      await _saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String plantName) async {
    final favorites = await getFavorites();
    favorites.removeWhere((plant) => plant['name'] == plantName);
    await _saveFavorites(favorites);
  }

  Future<bool> isFavorite(String plantName) async {
    final favorites = await getFavorites();
    return favorites.any((plant) => plant['name'] == plantName);
  }

  Future<void> _saveFavorites(List<Map<String, dynamic>> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = jsonEncode(favorites);
    await prefs.setString(_favoritesKey, favoritesString);
  }
} 