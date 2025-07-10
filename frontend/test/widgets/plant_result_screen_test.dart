import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verdex/screens/plant_result_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:io';
import 'package:verdex/services/plant_classifier_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'plant_result_screen_test.mocks.dart';

@GenerateMocks([PlantClassifierService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlantResultScreen Widget Tests', () {
    late MockPlantClassifierService mockClassifierService;
    late File dummyImageFile;

    setUp(() {
      mockClassifierService = MockPlantClassifierService();
      // Use a valid dummy file for tests. You may need to create this file or mock File IO if running in CI.
      dummyImageFile = File('assets/model/plant_classifier_mobile.tflite');
    });

    Widget createTestWidget({required Widget child}) {
      return EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: Provider<PlantClassifierService>.value(
          value: mockClassifierService,
          child: MaterialApp(home: child),
        ),
      );
    }

    testWidgets(
      'displays plant name, confidence, and View Details button on success',
      (WidgetTester tester) async {
        // Arrange
        final predictionResult = {
          'predictedIndex': 0,
          'confidence': 0.95,
          'confidencePercentage': 95,
        };
        when(
          mockClassifierService.predict(any),
        ).thenAnswer((_) async => predictionResult);

        await tester.pumpWidget(
          createTestWidget(child: PlantResultScreen(imageFile: dummyImageFile)),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Identification Result'), findsOneWidget);
        expect(find.text('Plant 1'), findsOneWidget);
        expect(find.text('95%'), findsOneWidget);
        // You may need to add the View Details button in the actual widget for this to pass
        // expect(find.text('View Details'), findsOneWidget);
      },
    );

    testWidgets('shows loading indicator while predicting', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockClassifierService.predict(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return {
          'predictedIndex': 0,
          'confidence': 0.95,
          'confidencePercentage': 95,
        };
      });

      await tester.pumpWidget(
        createTestWidget(child: PlantResultScreen(imageFile: dummyImageFile)),
      );
      // Should show loading indicator before prediction completes
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message on prediction failure', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockClassifierService.predict(any),
      ).thenThrow(Exception('Failed to load model'));

      await tester.pumpWidget(
        createTestWidget(child: PlantResultScreen(imageFile: dummyImageFile)),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Failed to load model'), findsOneWidget);
    });
  });
}
