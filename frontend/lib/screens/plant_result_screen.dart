import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/favorite_service.dart';
import '../widgets/feedback_form.dart';

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
    final isFavorite = await _favoriteService.isFavorite(widget.plantData['name']);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await _favoriteService.removeFavorite(widget.plantData['name']);
    } else {
      await _favoriteService.addFavorite(widget.plantData);
    }
    _checkFavoriteStatus();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US"); // This should be dynamic based on user settings
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final tags = (widget.plantData['tags'] as List).join(', ');

    return Scaffold(
      appBar: AppBar(title: Text(widget.plantData['name'])),
      body: SingleChildScrollView(
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
                  icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                  color: _isFavorite ? Colors.red : null,
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(widget.plantData['description']),
            const SizedBox(height: 24),
            _buildInfoRow('Family', widget.plantData['family']),
            _buildInfoRow('Category', widget.plantData['category']),
            _buildInfoRow('Uses', widget.plantData['uses']),
            _buildInfoRow('Tags', tags),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.feedback),
                  label: const Text('Feedback'),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => const FeedbackForm(),
                      isScrollControlled: true,
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text('Identify Another'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
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