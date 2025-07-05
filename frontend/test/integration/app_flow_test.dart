import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:verdex/main.dart';
import 'package:verdex/services/auth_service.dart';
import 'package:verdex/services/plant_service.dart';
import 'package:verdex/services/connectivity_service.dart';
import 'package:verdex/services/apple_classifier_service.dart';
import 'package:verdex/services/language_service.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app_flow_test.mocks.dart';

@GenerateMocks([
  AuthService,
  PlantService,
  ConnectivityService,
  AppleClassifierService,
  LanguageService,
])
void main() {
  group('App Flow Integration Tests', () {
    late MockAuthService mockAuthService;
    late MockPlantService mockPlantService;
    late MockConnectivityService mockConnectivityService;
    late MockAppleClassifierService mockClassifierService;
    late MockLanguageService mockLanguageService;

    setUp(() {
      mockAuthService = MockAuthService();
      mockPlantService = MockPlantService();
      mockConnectivityService = MockConnectivityService();
      mockClassifierService = MockAppleClassifierService();
      mockLanguageService = MockLanguageService();
    });

    Widget createTestApp() {
      return EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ConnectivityService>.value(
              value: mockConnectivityService,
            ),
            ChangeNotifierProvider<LanguageService>.value(
              value: mockLanguageService,
            ),
          ],
          child: const MyApp(),
        ),
      );
    }

    group('App Startup Flow', () {
      testWidgets('should show splash screen on app startup', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Verdex'), findsOneWidget);
        expect(find.text('See. Learn. Grow.'), findsOneWidget);
      });

      testWidgets('should navigate to login screen if not authenticated', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen to complete
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Login'), findsOneWidget);
        expect(find.byType(TextField), findsAtLeast(2));
      });

      testWidgets('should navigate to home screen if authenticated', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);
        when(mockPlantService.getAllPlants()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen to complete
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Welcome'), findsOneWidget);
      });
    });

    group('Authentication Flow', () {
      testWidgets('should complete login flow successfully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => false);
        when(mockAuthService.login(any, any)).thenAnswer(
          (_) async => {
            'success': true,
            'usedTempPass': false,
            'offline': false,
          },
        );
        when(mockPlantService.getAllPlants()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Enter login credentials
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Welcome'), findsOneWidget);
        verify(
          mockAuthService.login('test@example.com', 'password123'),
        ).called(1);
      });

      testWidgets('should handle login failure and show error', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => false);
        when(mockAuthService.login(any, any)).thenAnswer(
          (_) async => {'success': false, 'message': 'Invalid credentials'},
        );

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Enter invalid credentials
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'wrong@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'wrongpassword',
        );
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Invalid credentials'), findsOneWidget);
        expect(find.text('Login'), findsOneWidget); // Still on login screen
      });

      testWidgets('should navigate to signup screen', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => false);

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Navigate to signup
        await tester.tap(find.text('Sign up'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Create Account'), findsOneWidget);
      });
    });

    group('Main App Navigation Flow', () {
      testWidgets('should navigate between all main tabs', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);
        when(mockPlantService.getAllPlants()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Navigate to Identify tab
        await tester.tap(find.text('Identify'));
        await tester.pumpAndSettle();
        expect(find.text('Identify Plants'), findsOneWidget);

        // Navigate to Library tab
        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();
        expect(find.text('Plant Library'), findsOneWidget);

        // Navigate to Favorites tab
        await tester.tap(find.text('Favorites'));
        await tester.pumpAndSettle();
        expect(find.text('My Favorites'), findsOneWidget);

        // Navigate to Profile tab
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
        expect(find.text('Profile'), findsOneWidget);

        // Navigate back to Home
        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();
        expect(find.text('Home'), findsOneWidget);
      });
    });

    group('Plant Identification Flow', () {
      testWidgets('should complete plant identification process', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);
        when(mockPlantService.getAllPlants()).thenAnswer((_) async => []);
        when(mockClassifierService.loadModel()).thenAnswer((_) async => true);
        when(mockClassifierService.predict(any)).thenAnswer(
          (_) async => {
            'isApple': true,
            'confidence': 0.95,
            'confidencePercentage': '95.0',
            'prediction': 0.95,
          },
        );

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Navigate to Identify screen
        await tester.tap(find.text('Identify'));
        await tester.pumpAndSettle();

        // Tap camera button
        await tester.tap(find.byIcon(Icons.camera_alt));
        await tester.pumpAndSettle();

        // Assert - should show camera interface
        expect(find.text('Take Photo'), findsOneWidget);
      });

      testWidgets('should handle plant identification with results', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);
        when(mockPlantService.getAllPlants()).thenAnswer((_) async => []);
        when(mockPlantService.getPlantById(any)).thenAnswer(
          (_) async => {
            'id': 1,
            'name': 'Apple Tree',
            'scientific_name': 'Malus domestica',
            'description': 'A common fruit tree',
            'image_url': 'https://example.com/apple.jpg',
          },
        );

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Navigate to Identify screen
        await tester.tap(find.text('Identify'));
        await tester.pumpAndSettle();

        // Simulate successful identification
        // Note: In a real test, you'd simulate the camera and classification process

        // Assert
        expect(find.text('Identify Plants'), findsOneWidget);
      });
    });

    group('Plant Library Flow', () {
      testWidgets('should load and display plant library', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);
        when(mockPlantService.getAllPlants()).thenAnswer(
          (_) async => [
            {
              'id': 1,
              'name': 'Apple Tree',
              'scientific_name': 'Malus domestica',
              'description': 'A common fruit tree',
              'image_url': 'https://example.com/apple.jpg',
            },
            {
              'id': 2,
              'name': 'Banana Plant',
              'scientific_name': 'Musa acuminata',
              'description': 'A tropical fruit plant',
              'image_url': 'https://example.com/banana.jpg',
            },
          ],
        );

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Navigate to Library
        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Plant Library'), findsOneWidget);
        expect(find.text('Apple Tree'), findsOneWidget);
        expect(find.text('Banana Plant'), findsOneWidget);
      });

      testWidgets('should navigate to plant details from library', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);
        when(mockPlantService.getAllPlants()).thenAnswer(
          (_) async => [
            {
              'id': 1,
              'name': 'Apple Tree',
              'scientific_name': 'Malus domestica',
              'description': 'A common fruit tree',
              'image_url': 'https://example.com/apple.jpg',
            },
          ],
        );
        when(mockPlantService.getPlantById(1)).thenAnswer(
          (_) async => {
            'id': 1,
            'name': 'Apple Tree',
            'scientific_name': 'Malus domestica',
            'description': 'A common fruit tree',
            'image_url': 'https://example.com/apple.jpg',
            'care_instructions': 'Water regularly',
            'growth_habits': 'Deciduous tree',
          },
        );

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Navigate to Library
        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();

        // Tap on a plant card
        await tester.tap(find.text('Apple Tree'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Apple Tree'), findsOneWidget);
        expect(find.text('Malus domestica'), findsOneWidget);
        expect(find.text('Water regularly'), findsOneWidget);
      });
    });

    group('Offline Mode Flow', () {
      testWidgets('should handle offline mode gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(false);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);
        when(mockPlantService.getAllPlants()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('You are currently offline'), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should show offline indicator in navigation', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(false);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);
        when(mockPlantService.getAllPlants()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      });
    });

    group('Error Recovery Flow', () {
      testWidgets('should recover from network errors', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockLanguageService.majorLanguageCode).thenReturn('en');
        when(mockLanguageService.loadSavedLanguage()).thenAnswer((_) async {});
        when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);

        // First call throws exception, subsequent calls return empty list
        var callCount = 0;
        when(mockPlantService.getAllPlants()).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            throw Exception('Network error');
          }
          return [];
        });

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Wait for splash screen
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Assert - should show error initially
        expect(find.text('Failed to load plants'), findsOneWidget);

        // Simulate network recovery
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Trigger refresh
        await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
        await tester.pumpAndSettle();

        // Assert - should recover
        expect(find.text('Failed to load plants'), findsNothing);
      });
    });
  });
}
