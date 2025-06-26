import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../services/plant_service.dart';
import 'plant_result_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_nav_bar.dart';
import 'main_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final PlantService _plantService = PlantService();
  late Future<List<Map<String, dynamic>>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoritesFuture = _fetchFavoritePlants();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchFavoritePlants() async {
    final favoriteIds = await _favoriteService.getFavorites();
    final allPlants = await _plantService.getAllPlants();
    return allPlants
        .where((plant) => favoriteIds.contains(plant['id']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('favorites'.tr())),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100), // for navbar
        child: RefreshIndicator(
          onRefresh: () async {
            _loadFavorites();
          },
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _favoritesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text('error_loading_favorites'.tr()),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
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
                                (context) =>
                                    PlantResultScreen(plantData: plant),
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
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: null,
        onTabSelected: (index) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => MainScreen(initialIndex: index)),
            (route) => false,
          );
        },
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final double size;
  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              selected
                  ? const Color(0xFF4CAF50).withOpacity(0.12)
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: size,
          color: selected ? const Color(0xFF4CAF50) : Colors.grey.shade500,
        ),
      ),
    );
  }
}
