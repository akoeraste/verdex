import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/favorite_service.dart';
import '../widgets/feedback_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_nav_bar.dart';

class PlantResultScreen extends StatefulWidget {
  final Map<String, dynamic> plantData;

  const PlantResultScreen({super.key, required this.plantData});

  @override
  PlantResultScreenState createState() => PlantResultScreenState();
}

class PlantResultScreenState extends State<PlantResultScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final plantId = widget.plantData['id'];
    if (plantId != null) {
      final isFav = await _favoriteService.isFavorite(plantId);
      if (mounted) setState(() => _isFavorite = isFav);
    }
  }

  Future<void> _toggleFavorite() async {
    final plantId = widget.plantData['id'];
    if (plantId == null) return;
    if (_isFavorite) {
      await _favoriteService.removeFavorite(plantId);
    } else {
      await _favoriteService.addFavorite(plantId);
    }
    _checkFavoriteStatus();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage(
      context.locale.toString().replaceAll('_', '-'),
    ); // This should be dynamic based on user settings
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final tags = (widget.plantData['tags'] as List).join(', ');

    return Scaffold(
      appBar: AppBar(title: Text(widget.plantData['name'])),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100), // for navbar
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.plantData['image_url'],
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    widget.plantData['name'],
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () => _speak(widget.plantData['name']),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    color: _isFavorite ? Colors.red : null,
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(widget.plantData['description']),
              const SizedBox(height: 24),
              _buildInfoRow('plantFamily'.tr(), widget.plantData['family']),
              _buildInfoRow('plantCategory'.tr(), widget.plantData['category']),
              _buildInfoRow('plantUses'.tr(), widget.plantData['uses']),
              _buildInfoRow('tags'.tr(), tags),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.feedback),
                    label: Text('feedback'.tr()),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const FeedbackForm(),
                        isScrollControlled: true,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('identify_another'.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            // Already here
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
