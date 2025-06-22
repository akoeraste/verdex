import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/plant_service.dart';
import 'plant_result_screen.dart';

class IdentifyScreen extends StatefulWidget {
  const IdentifyScreen({super.key});

  @override
  IdentifyScreenState createState() => IdentifyScreenState();
}

class IdentifyScreenState extends State<IdentifyScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final PlantService _plantService = PlantService();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  void _identifyPlant() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    final result = await _plantService.identifyPlant(_image!);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantResultScreen(plantData: result),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not identify the plant.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identify Plant')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _image == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take a Photo'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Select from Gallery'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.file(_image!, height: 300),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _clearImage,
                            child: const Text('Retake'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _identifyPlant,
                            child: const Text('Confirm'),
                          ),
                        ],
                      )
                    ],
                  ),
      ),
    );
  }
} 