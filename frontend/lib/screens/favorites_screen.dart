import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import 'plant_result_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  late Future<List<Map<String, dynamic>>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoritesFuture = _favoriteService.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('favorites'.tr())),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadFavorites();
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('error_loading_favorites'.tr()));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('no_favorites'.tr()));
            } else {
              final favorites = snapshot.data!;
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final plant = favorites[index];
                  return ListTile(
                    leading: Image.network(
                      plant['image_url'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(plant['name']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PlantResultScreen(plantData: plant),
                        ),
                      ).then((_) => _loadFavorites());
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
