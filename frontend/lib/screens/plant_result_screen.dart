import 'package:flutter/material.dart';
import 'dart:io';
import 'package:verdex/screens/plant_details_screen.dart';

class PlantResultScreen extends StatefulWidget {
  final File imageFile;
  // Simulate identification result for now
  final Map<String, dynamic>? identifiedPlant;

  const PlantResultScreen({
    super.key,
    required this.imageFile,
    this.identifiedPlant,
  });

  @override
  State<PlantResultScreen> createState() => _PlantResultScreenState();
}

class _PlantResultScreenState extends State<PlantResultScreen> {
  @override
  Widget build(BuildContext context) {
    final bool identified = widget.identifiedPlant != null;
    return Scaffold(
      appBar: AppBar(title: Text('Plant Identification Result')),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100), // for navbar
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.file(
                  widget.imageFile,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                identified ? 'Plant Identified!' : 'Could not identify plant',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: identified ? Colors.green[800] : Colors.red[700],
                ),
              ),
              const SizedBox(height: 16),
              if (identified)
                Column(
                  children: [
                    Text(
                      widget.identifiedPlant!['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.identifiedPlant!['description'] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PlantDetailsScreen(
                                  plant: widget.identifiedPlant!,
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Show more details',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Identify another plant',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
