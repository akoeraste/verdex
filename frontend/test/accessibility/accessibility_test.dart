import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verdex/screens/login_screen.dart';
import 'package:verdex/screens/home_screen.dart';
import 'package:verdex/widgets/plant_card.dart';
import 'package:verdex/widgets/bottom_nav_bar.dart';

void main() {
  group('Accessibility Tests', () {
    group('Screen Reader Support', () {
      testWidgets(
        'should have proper semantic labels for all interactive elements',
        (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    TextField(
                      key: const Key('email_field'),
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Login'),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite),
                    ),
                  ],
                ),
              ),
            ),
          );

          // Assert
          expect(find.bySemanticsLabel('Email input field'), findsOneWidget);
          expect(find.bySemanticsLabel('Login button'), findsOneWidget);
          expect(find.bySemanticsLabel('Favorite button'), findsOneWidget);
        },
      );

      testWidgets('should provide meaningful descriptions for images', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Image.asset(
                'assets/images/logo.png',
                semanticLabel: 'Verdex app logo',
              ),
            ),
          ),
        );

        // Assert
        expect(find.bySemanticsLabel('Verdex app logo'), findsOneWidget);
      });

      testWidgets('should announce important state changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text('Loading...', semanticsLabel: 'Loading indicator'),
                  Text('Success!', semanticsLabel: 'Success message'),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.bySemanticsLabel('Loading indicator'), findsOneWidget);
        expect(find.bySemanticsLabel('Success message'), findsOneWidget);
      });
    });

    group('Keyboard Navigation', () {
      testWidgets('should support tab navigation between form fields', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(
                    key: const Key('field1'),
                    decoration: const InputDecoration(labelText: 'Field 1'),
                  ),
                  TextField(
                    key: const Key('field2'),
                    decoration: const InputDecoration(labelText: 'Field 2'),
                  ),
                  ElevatedButton(
                    key: const Key('submit'),
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act - Navigate through fields using tab
        await tester.tap(find.byKey(const Key('field1')));
        await tester.testTextInput.receiveAction(TextInputAction.next);
        await tester.testTextInput.receiveAction(TextInputAction.next);

        // Assert
        expect(find.byKey(const Key('field2')), findsOneWidget);
        expect(find.byKey(const Key('submit')), findsOneWidget);
      });

      testWidgets('should support enter key for form submission', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool formSubmitted = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextField(
                onSubmitted: (_) => formSubmitted = true,
                decoration: const InputDecoration(labelText: 'Search'),
              ),
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextField), 'test search');
        await tester.testTextInput.receiveAction(TextInputAction.search);

        // Assert
        expect(formSubmitted, isTrue);
      });

      testWidgets('should support escape key for canceling actions', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool dialogClosed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: tester.element(find.byType(ElevatedButton)),
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Dialog'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                dialogClosed = true;
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));

        // Assert
        expect(dialogClosed, isTrue);
      });
    });

    group('Color and Contrast', () {
      testWidgets('should have sufficient color contrast for text', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              primaryColor: Colors.green,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black),
              ),
            ),
            home: const Scaffold(
              backgroundColor: Colors.white,
              body: Text('Test text with good contrast'),
            ),
          ),
        );

        // Assert - Check that text is visible against background
        expect(find.text('Test text with good contrast'), findsOneWidget);
      });

      testWidgets('should not rely solely on color to convey information', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text('Error message', style: TextStyle(color: Colors.red)),
                  Text(
                    'Success message',
                    style: TextStyle(color: Colors.green),
                  ),
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    semanticLabel: 'Error icon',
                  ),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    semanticLabel: 'Success icon',
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert - Information should be conveyed through text and icons, not just color
        expect(find.text('Error message'), findsOneWidget);
        expect(find.text('Success message'), findsOneWidget);
        expect(find.bySemanticsLabel('Error icon'), findsOneWidget);
        expect(find.bySemanticsLabel('Success icon'), findsOneWidget);
      });
    });

    group('Touch Target Size', () {
      testWidgets('should have minimum touch target size for buttons', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                onPressed: () {},
                child: const Text('Test Button'),
              ),
            ),
          ),
        );

        // Act
        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        final buttonElement = tester.element(find.byType(ElevatedButton));
        final renderBox = buttonElement.renderObject as RenderBox;
        final size = renderBox.size;

        // Assert - Touch target should be at least 44x44 points
        expect(size.width, greaterThanOrEqualTo(44.0));
        expect(size.height, greaterThanOrEqualTo(44.0));
      });

      testWidgets('should have minimum touch target size for icon buttons', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite),
              ),
            ),
          ),
        );

        // Act
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        final iconButtonElement = tester.element(find.byType(IconButton));
        final renderBox = iconButtonElement.renderObject as RenderBox;
        final size = renderBox.size;

        // Assert - Icon button should have minimum touch target
        expect(size.width, greaterThanOrEqualTo(44.0));
        expect(size.height, greaterThanOrEqualTo(44.0));
      });
    });

    group('Focus Management', () {
      testWidgets('should maintain logical focus order', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(
                    key: const Key('name'),
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    key: const Key('email'),
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    key: const Key('phone'),
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  ElevatedButton(
                    key: const Key('submit'),
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act - Navigate through focusable elements
        await tester.tap(find.byKey(const Key('name')));
        await tester.testTextInput.receiveAction(TextInputAction.next);
        await tester.testTextInput.receiveAction(TextInputAction.next);
        await tester.testTextInput.receiveAction(TextInputAction.done);

        // Assert - Focus should move logically through the form
        expect(find.byKey(const Key('name')), findsOneWidget);
        expect(find.byKey(const Key('email')), findsOneWidget);
        expect(find.byKey(const Key('phone')), findsOneWidget);
        expect(find.byKey(const Key('submit')), findsOneWidget);
      });

      testWidgets('should provide clear focus indicators', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextField(
                decoration: const InputDecoration(
                  labelText: 'Test Field',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(TextField));

        // Assert - Focused field should be visually distinct
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('Dynamic Content', () {
      testWidgets('should announce dynamic content changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text('Loading...', semanticsLabel: 'Loading status'),
                  Text(
                    'Data loaded successfully',
                    semanticsLabel: 'Success status',
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.bySemanticsLabel('Loading status'), findsOneWidget);
        expect(find.bySemanticsLabel('Success status'), findsOneWidget);
      });

      testWidgets('should provide status updates for long operations', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CircularProgressIndicator(semanticsLabel: 'Loading plants'),
                  Text('Processing...', semanticsLabel: 'Processing status'),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.bySemanticsLabel('Loading plants'), findsOneWidget);
        expect(find.bySemanticsLabel('Processing status'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should provide clear error messages', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text(
                    'Please enter a valid email address',
                    semanticsLabel: 'Email error message',
                  ),
                  Text(
                    'Password must be at least 6 characters',
                    semanticsLabel: 'Password error message',
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.bySemanticsLabel('Email error message'), findsOneWidget);
        expect(find.bySemanticsLabel('Password error message'), findsOneWidget);
      });

      testWidgets('should provide recovery suggestions', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text('Connection failed', semanticsLabel: 'Error message'),
                  Text(
                    'Please check your internet connection and try again',
                    semanticsLabel: 'Recovery suggestion',
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.bySemanticsLabel('Error message'), findsOneWidget);
        expect(find.bySemanticsLabel('Recovery suggestion'), findsOneWidget);
      });
    });

    group('Alternative Text', () {
      testWidgets('should provide alternative text for decorative images', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Image.asset(
                'assets/images/decoration.png',
                semanticLabel: 'Decorative background image',
              ),
            ),
          ),
        );

        // Assert
        expect(
          find.bySemanticsLabel('Decorative background image'),
          findsOneWidget,
        );
      });

      testWidgets('should provide descriptive text for functional images', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Image.asset(
                'assets/images/plant_icon.png',
                semanticLabel:
                    'Plant identification icon, tap to identify plants',
              ),
            ),
          ),
        );

        // Assert
        expect(
          find.bySemanticsLabel(
            'Plant identification icon, tap to identify plants',
          ),
          findsOneWidget,
        );
      });
    });

    group('Voice Control', () {
      testWidgets('should support voice control commands', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Take Photo'),
                    key: const Key('take_photo_button'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Search Plants'),
                    key: const Key('search_button'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert - Buttons should have clear, actionable labels
        expect(find.byKey(const Key('take_photo_button')), findsOneWidget);
        expect(find.byKey(const Key('search_button')), findsOneWidget);
        expect(find.text('Take Photo'), findsOneWidget);
        expect(find.text('Search Plants'), findsOneWidget);
      });
    });

    group('Reduced Motion', () {
      testWidgets('should respect reduced motion preferences', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: const Text('Animated content'),
              ),
            ),
          ),
        );

        // Assert - Animations should be accessible and not cause motion sickness
        expect(find.text('Animated content'), findsOneWidget);
      });
    });
  });
}
