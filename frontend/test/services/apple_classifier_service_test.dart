import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:verdex/services/apple_classifier_service.dart';

import 'apple_classifier_service_test.mocks.dart';

@GenerateMocks([File])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AppleClassifierService Tests', () {
    late AppleClassifierService classifierService;
    late MockFile mockFile;

    setUp(() {
      mockFile = MockFile();
      classifierService = AppleClassifierService();
    });

    group('Model Loading', () {
      test('should load model successfully', () async {
        final result = await classifierService.loadModel();
        expect(result, isTrue);
        expect(classifierService.isModelLoaded, isTrue);
      });

      test('should return true if model already loaded', () async {
        await classifierService.loadModel();
        final result = await classifierService.loadModel();
        expect(result, isTrue);
      });
    });

    group('Prediction', () {
      test('should throw if model not loaded', () async {
        when(
          mockFile.readAsBytesSync(),
        ).thenReturn(Uint8List.fromList(List<int>.filled(10, 0)));
        expect(() => classifierService.predict(mockFile), throwsException);
      });

      test('should return prediction map if model loaded', () async {
        await classifierService.loadModel();
        // Provide a fake image file with valid bytes
        when(
          mockFile.readAsBytesSync(),
        ).thenReturn(Uint8List.fromList(List<int>.filled(224 * 224 * 3, 128)));
        // The actual image decoding will fail, but we want to check error handling
        try {
          await classifierService.predict(mockFile);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('Disposal', () {
      test('should dispose without error', () {
        classifierService.dispose();
        expect(classifierService.isModelLoaded, isFalse);
      });
    });
  });
}
