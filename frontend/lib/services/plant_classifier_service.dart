import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math' as math;

class PlantClassifierService {
  static const String _modelPath = 'assets/model/mobilenetv3_plant_classifier.tflite';
  static const int _inputSize = 224;
  static const int _numClasses = 29; // Model outputs 29 classes
  static const double _confidenceThreshold = 0.5;

  // === NEW: Class labels (ensure this matches your model's training order) ===
  static const List<String> classLabels = [
    'aloevera',
    'banana',
    'bilimbi',
    'cantaloupe',
    'cassava',
    'coconut',
    'corn',
    'cucumber',
    'curcuma',
    'eggplant',
    'galangal',
    'ginger',
    'guava',
    'kale',
    'longbeans',
    'mango',
    'melon',
    'orange',
    'paddy',
    'papaya',
    'peperchili',
    'pineapple',
    'pomelo',
    'shallot',
    'soybeans',
    'spinach',
    'sweetpotatoes',
    'waterapple',
    'watermelon',
  ];

  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  // === NEW: Configurable preprocessing ===
  bool useBGR = false; // Set to true if model expects BGR
  String normalization = '0_255'; // Model expects uint8 input, so use 0_255
  bool channelsFirst = false; // Set to true if model expects [1, 3, 224, 224]

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
  List preprocessImage(File imageFile) {
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

      // Convert to int array for uint8 input
      List inputArray;
      if (channelsFirst) {
        // [1, 3, 224, 224]
        inputArray = List.generate(
          1,
          (batch) => List.generate(
            3,
            (channel) => List.generate(
              _inputSize,
              (height) => List.generate(_inputSize, (width) {
                int r = (resizedImage.getPixel(width, height).r).toInt();
                int g = (resizedImage.getPixel(width, height).g).toInt();
                int b = (resizedImage.getPixel(width, height).b).toInt();
                List<int> rgb = [r, g, b];
                if (useBGR) rgb = [b, g, r];
                // For uint8, just return the int value
                return rgb[channel];
              }),
            ),
          ),
        );
      } else {
        // [1, 224, 224, 3]
        inputArray = List.generate(
          1,
          (batch) => List.generate(
            _inputSize,
            (height) => List.generate(
              _inputSize,
              (width) => List.generate(3, (channel) {
                int r = (resizedImage.getPixel(width, height).r).toInt();
                int g = (resizedImage.getPixel(width, height).g).toInt();
                int b = (resizedImage.getPixel(width, height).b).toInt();
                List<int> rgb = [r, g, b];
                if (useBGR) rgb = [b, g, r];
                // For uint8, just return the int value
                return rgb[channel];
              }),
            ),
          ),
        );
      }

      // Debug: Print input stats
      int minVal = 255, maxVal = 0;
      for (var v in _flattenInputArray(inputArray, channelsFirst)) {
        minVal = math.min(minVal, v);
        maxVal = math.max(maxVal, v);
      }
      print(
        '🟦 Preprocessed input shape: ${channelsFirst ? '[1,3,224,224]' : '[1,224,224,3]'} min=$minVal max=$maxVal',
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
      final inputArray = preprocessImage(imageFile);

      // Prepare output tensor for multi-class classification
      final outputArray = List.generate(
        1,
        (_) => List.filled(_numClasses, 0), // int for uint8 output
      );

      // Debug: Print input/output types
      print(
        '🟦 Interpreter input type: ${_interpreter!.getInputTensor(0).type} shape: ${_interpreter!.getInputTensor(0).shape}',
      );
      print(
        '🟦 Interpreter output type: ${_interpreter!.getOutputTensor(0).type} shape: ${_interpreter!.getOutputTensor(0).shape}',
      );

      // Run inference
      _interpreter!.run(inputArray, outputArray);

      // Convert output to double probabilities
      List<double> probabilities = List<double>.from(
        (outputArray[0] as List).map((v) => (v as int).toDouble()),
      );
      double sum = probabilities.fold(0.0, (a, b) => a + b);
      if (sum < 0.99 || sum > 1.01) {
        // Not normalized, apply softmax
        final exp = probabilities.map((x) => math.exp(x)).toList();
        final expSum = exp.fold(0.0, (a, b) => a + b);
        probabilities = exp.map((x) => x / expSum).toList();
      }

      // Get prediction result
      final int predictedIndex = probabilities.indexWhere(
        (p) => p == probabilities.reduce((a, b) => a > b ? a : b),
      );
      final double confidence = probabilities[predictedIndex];
      final String predictedLabel =
          (predictedIndex >= 0 && predictedIndex < classLabels.length)
              ? classLabels[predictedIndex]
              : 'Unknown';

      // Determine if the prediction is valid
      final bool couldNotIdentify =
        confidence < _confidenceThreshold ||
        !classLabels.contains(predictedLabel);

      print(
        '🟦 Prediction: index=$predictedIndex label=$predictedLabel confidence=$confidence',
      );

      return {
        'predictedIndex': predictedIndex,
        'predictedLabel': predictedLabel,
        'confidence': confidence,
        'confidencePercentage': (confidence * 100).toStringAsFixed(1),
        'probabilities': probabilities,
        'classLabels': classLabels,
        'couldNotIdentify': couldNotIdentify,
      };
    } catch (e) {
      print('❌ Error during prediction: $e');
      return {
        'error': e.toString(),
        'couldNotIdentify': true,
      };
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

  // Helper to flatten input array for min/max calculation
  Iterable<int> _flattenInputArray(List inputArray, bool channelsFirst) {
    if (channelsFirst) {
      // [1, 3, 224, 224]
      return inputArray.expand((batch) =>
        (batch as List).expand((channel) =>
          (channel as List).expand((row) =>
            (row as List).cast<int>()
          )
        )
      );
    } else {
      // [1, 224, 224, 3]
      return inputArray.expand((batch) =>
        (batch as List).expand((row) =>
          (row as List).expand((col) =>
            (col as List).cast<int>()
          )
        )
      );
    }
  }
}
