import 'package:flutter/material.dart';
import 'dart:io';
import '../services/plant_service.dart';
import '../screens/plant_details_screen.dart';

class PlantResultScreen extends StatelessWidget {
  final File imageFile;
  final Map<String, dynamic> predictionResult;

  const PlantResultScreen({
    Key? key,
    required this.imageFile,
    required this.predictionResult,
  }) : super(key: key);

  Future<void> _navigateToPlantDetails(BuildContext context, String predictedLabel) async {
    try {
      final plantService = PlantService();
      final plant = await plantService.findPlantByScientificName(predictedLabel);
      
      if (plant != null) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailsScreen(plant: plant),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Plant details not found. Please try again later.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading plant details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final couldNotIdentify = predictionResult['couldNotIdentify'] == true;
    final error = predictionResult['error'];
    final predictedLabel = predictionResult['predictedLabel'] ?? '';
    final confidence = predictionResult['confidence'] != null
        ? (predictionResult['confidence'] * 100).toStringAsFixed(1)
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF667EEA),
        elevation: 0,
        title: const Text(
          'Identification Result',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image preview
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    imageFile,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Result card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: error != null
                    ? Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'An error occurred:\n$error',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : couldNotIdentify
                        ? Column(
                            children: [
                              const Icon(Icons.help_outline, color: Color(0xFF667EEA), size: 48),
                              const SizedBox(height: 16),
                              const Text(
                                'Could not identify this plant.',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF667EEA),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Try another photo or make sure the plant is clearly visible.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF444444),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const Icon(Icons.eco, color: Color(0xFF667EEA), size: 48),
                              const SizedBox(height: 16),
                              Text(
                                predictedLabel[0].toUpperCase() + predictedLabel.substring(1),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Confidence: $confidence%',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF667EEA),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // View Details Button
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  elevation: 2,
                                ),
                                icon: const Icon(Icons.info_outline, color: Colors.white, size: 20),
                                label: const Text(
                                  'View Details',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                                onPressed: () => _navigateToPlantDetails(context, predictedLabel),
                              ),
                            ],
                          ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 2,
                ),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  'Identify Another Plant',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
