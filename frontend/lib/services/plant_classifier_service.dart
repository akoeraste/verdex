import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class PlantClassifierService {
  static const String _modelPath = 'plant_classifier_mobile.tflite';
  static const int _inputSize = 224;
  static const int _numClasses = 30;
  static const double _confidenceThreshold = 0.5;

  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  /// Load the TFLite model from assets
  Future<bool> loadModel() async {
    try {
      if (_isModelLoaded && _interpreter != null) {
        return true;
      }

      // Load model from assets
      final modelData = await rootBundle.load(_modelPath);
      final modelBuffer = modelData.buffer.asUint8List();

      // Create interpreter
      _interpreter = await Interpreter.fromBuffer(modelBuffer);
      _isModelLoaded = true;

      print('✅ Plant classifier model loaded successfully');
      return true;
    } catch (e) {
      print('❌ Error loading plant classifier model: $e');
      _isModelLoaded = false;
      return false;
    }
  }

  /// Preprocess image for the model
  List<List<List<List<double>>>> _preprocessImage(File imageFile) {
    try {
      // Read image file
      final imageBytes = imageFile.readAsBytesSync();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize image to 224x224
      final resizedImage = img.copyResize(
        image,
        width: _inputSize,
        height: _inputSize,
      );

      // Convert to float array and normalize to [0, 1]
      final inputArray = List.generate(
        1,
        (batch) => List.generate(
          _inputSize,
          (height) => List.generate(
            _inputSize,
            (width) => List.generate(
              3, // RGB channels
              (channel) {
                final pixel = resizedImage.getPixel(width, height);
                double value;
                switch (channel) {
                  case 0: // Red
                    value = pixel.r / 255.0;
                    break;
                  case 1: // Green
                    value = pixel.g / 255.0;
                    break;
                  case 2: // Blue
                    value = pixel.b / 255.0;
                    break;
                  default:
                    value = 0.0;
                }
                return value;
              },
            ),
          ),
        ),
      );

      return inputArray;
    } catch (e) {
      print('❌ Error preprocessing image: $e');
      rethrow;
    }
  }

  /// Run prediction on the image
  Future<Map<String, dynamic>> predict(File imageFile) async {
    try {
      // Ensure model is loaded
      if (!_isModelLoaded || _interpreter == null) {
        final loaded = await loadModel();
        if (!loaded) {
          throw Exception('Failed to load model');
        }
      }

      // Preprocess image
      final inputArray = _preprocessImage(imageFile);

      // Prepare output tensor for multi-class classification
      final outputArray = List.generate(
        1,
        (_) => List.filled(_numClasses, 0.0),
      );

      // Run inference
      _interpreter!.run(inputArray, outputArray);

      // Get prediction result
      final List<double> probabilities = List<double>.from(outputArray[0]);
      final int predictedIndex = probabilities.indexWhere(
        (p) => p == probabilities.reduce((a, b) => a > b ? a : b),
      );
      final double confidence = probabilities[predictedIndex];

      return {
        'predictedIndex': predictedIndex,
        'confidence': confidence,
        'confidencePercentage': (confidence * 100).toStringAsFixed(1),
        'probabilities': probabilities,
      };
    } catch (e) {
      print('❌ Error during prediction: $e');
      rethrow;
    }
  }

  /// Dispose the interpreter
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isModelLoaded = false;
  }

  /// Check if model is loaded
  bool get isModelLoaded => _isModelLoaded;
}
