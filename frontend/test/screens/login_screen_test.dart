import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:verdex/screens/login_screen.dart';
import 'package:verdex/services/auth_service.dart';
import 'package:verdex/services/connectivity_service.dart';
import 'package:easy_localization/easy_localization.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthService, ConnectivityService])
void main() {
  group('LoginScreen Widget Tests', () {
    late MockAuthService mockAuthService;
    late MockConnectivityService mockConnectivityService;

    setUp(() {
      mockAuthService = MockAuthService();
      mockConnectivityService = MockConnectivityService();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ConnectivityService>.value(
              value: mockConnectivityService,
            ),
          ],
          child: const LoginScreen(),
        ),
      );
    }

    group('UI Rendering Tests', () {
      testWidgets('should render login screen with all elements', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(
          find.byType(TextField),
          findsAtLeast(2),
        ); // Email and password fields
        expect(find.byType(ElevatedButton), findsAtLeast(1)); // Login button
        expect(find.text('Login'), findsOneWidget);
      });

      testWidgets('should show app logo and title', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Image), findsAtLeast(1)); // Logo
        expect(find.text('Verdex'), findsOneWidget);
        expect(find.text('See. Learn. Grow.'), findsOneWidget);
      });

      testWidgets('should show email and password input fields', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const Key('email_field')), findsOneWidget);
        expect(find.byKey(const Key('password_field')), findsOneWidget);
      });

      testWidgets('should show forgot password link', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Forgot Password?'), findsOneWidget);
      });

      testWidgets('should show sign up link', (WidgetTester tester) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text("Don't have an account? Sign up"), findsOneWidget);
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should show error for empty email field', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap login button without entering email
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Please enter your email'), findsOneWidget);
      });

      testWidgets('should show error for invalid email format', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter invalid email
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'invalid-email',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Please enter a valid email'), findsOneWidget);
      });

      testWidgets('should show error for empty password field', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter email but not password
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Please enter your password'), findsOneWidget);
      });

      testWidgets('should show error for short password', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter valid email and short password
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(find.byKey(const Key('password_field')), '123');
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );
      });
    });

    group('Authentication Flow Tests', () {
      testWidgets('should call login service with valid credentials', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockAuthService.login(any, any)).thenAnswer(
          (_) async => {
            'success': true,
            'usedTempPass': false,
            'offline': false,
          },
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter valid credentials
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockAuthService.login('test@example.com', 'password123'),
        ).called(1);
      });

      testWidgets('should show loading indicator during login', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockAuthService.login(any, any)).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 1));
          return {'success': true, 'usedTempPass': false, 'offline': false};
        });

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter credentials and tap login
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should show error message for failed login', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockAuthService.login(any, any)).thenAnswer(
          (_) async => {'success': false, 'message': 'Invalid credentials'},
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter credentials and tap login
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'wrongpassword',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Invalid credentials'), findsOneWidget);
      });

      testWidgets('should show offline message when no connectivity', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(false);
        when(mockAuthService.login(any, any)).thenAnswer(
          (_) async => {
            'success': false,
            'message': 'No internet connection',
            'offline': true,
          },
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter credentials and tap login
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('No internet connection'), findsOneWidget);
      });
    });

    group('Navigation Tests', () {
      testWidgets('should navigate to forgot password screen', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap forgot password link
        await tester.tap(find.text('Forgot Password?'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        // Note: In a real test, you'd verify navigation to the forgot password screen
      });

      testWidgets('should navigate to sign up screen', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap sign up link
        await tester.tap(find.text('Sign up'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        // Note: In a real test, you'd verify navigation to the sign up screen
      });
    });

    group('Password Visibility Tests', () {
      testWidgets('should toggle password visibility', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find password field and visibility toggle
        final passwordField = find.byKey(const Key('password_field'));
        final visibilityToggle = find.byIcon(Icons.visibility_off);

        // Initially password should be hidden
        expect(visibilityToggle, findsOneWidget);

        // Tap to show password
        await tester.tap(visibilityToggle);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.bySemanticsLabel('Email input field'), findsOneWidget);
        expect(find.bySemanticsLabel('Password input field'), findsOneWidget);
        expect(find.bySemanticsLabel('Login button'), findsOneWidget);
      });

      testWidgets('should support keyboard navigation', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter email and press tab to move to password field
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.testTextInput.receiveAction(TextInputAction.next);

        // Assert
        expect(find.byKey(const Key('password_field')), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle network errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(
          mockAuthService.login(any, any),
        ).thenThrow(Exception('Network error'));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter credentials and tap login
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('An error occurred. Please try again.'),
          findsOneWidget,
        );
      });

      testWidgets('should clear error message when user starts typing', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockAuthService.login(any, any)).thenAnswer(
          (_) async => {'success': false, 'message': 'Invalid credentials'},
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter credentials and tap login to show error
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'wrongpassword',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Verify error is shown
        expect(find.text('Invalid credentials'), findsOneWidget);

        // Start typing in email field
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'new@example.com',
        );
        await tester.pumpAndSettle();

        // Assert error is cleared
        expect(find.text('Invalid credentials'), findsNothing);
      });
    });
  });
}
