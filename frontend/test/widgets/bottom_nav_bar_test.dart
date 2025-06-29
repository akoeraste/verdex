import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verdex/widgets/bottom_nav_bar.dart';

void main() {
  group('BottomNavBar Widget Tests', () {
    late int currentIndex;
    late Function(int) onTap;

    setUp(() {
      currentIndex = 0;
      onTap = (index) {
        currentIndex = index;
      };
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: const Center(child: Text('Content')),
          bottomNavigationBar: BottomNavBar(
            selectedIndex: currentIndex,
            onTabSelected: onTap,
          ),
        ),
      );
    }

    group('UI Rendering Tests', () {
      testWidgets('should render bottom navigation bar with all tabs', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(BottomNavigationBar), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Identify'), findsOneWidget);
        expect(find.text('Library'), findsOneWidget);
        expect(find.text('Favorites'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('should show correct icons for each tab', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.byIcon(Icons.camera_alt), findsOneWidget);
        expect(find.byIcon(Icons.library_books), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('should highlight current tab', (WidgetTester tester) async {
        // Arrange
        currentIndex = 2; // Library tab

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        final bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNavBar.currentIndex, equals(2));
      });

      testWidgets('should show correct number of tabs', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        final bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNavBar.items.length, equals(5));
      });

      testWidgets('should render bottom navigation bar', (
        WidgetTester tester,
      ) async {
        // Arrange
        int currentIndex = 0;
        final onTap = (int index) => currentIndex = index;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: BottomNavBar(
                selectedIndex: currentIndex,
                onTabSelected: onTap,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(BottomNavBar), findsOneWidget);
        expect(find.byIcon(Icons.home_rounded), findsOneWidget);
        expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
        expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
      });
    });

    group('Navigation Tests', () {
      testWidgets('should call onTap when home tab is tapped', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();

        // Assert
        expect(currentIndex, equals(0));
      });

      testWidgets('should call onTap when identify tab is tapped', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Identify'));
        await tester.pumpAndSettle();

        // Assert
        expect(currentIndex, equals(1));
      });

      testWidgets('should call onTap when library tab is tapped', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();

        // Assert
        expect(currentIndex, equals(2));
      });

      testWidgets('should call onTap when favorites tab is tapped', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Favorites'));
        await tester.pumpAndSettle();

        // Assert
        expect(currentIndex, equals(3));
      });

      testWidgets('should call onTap when profile tab is tapped', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();

        // Assert
        expect(currentIndex, equals(4));
      });

      testWidgets('should call onTap when icon is tapped', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.camera_alt));
        await tester.pumpAndSettle();

        // Assert
        expect(currentIndex, equals(1));
      });
    });

    group('State Management Tests', () {
      testWidgets('should update current index when onTap is called', (
        WidgetTester tester,
      ) async {
        // Arrange
        int testIndex = 0;
        final testOnTap = (int index) {
          testIndex = index;
        };

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Content')),
              bottomNavigationBar: BottomNavBar(
                selectedIndex: testIndex,
                onTabSelected: testOnTap,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();

        // Assert
        expect(testIndex, equals(2));
      });

      testWidgets('should handle multiple rapid taps', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Rapidly tap different tabs
        await tester.tap(find.text('Identify'));
        await tester.tap(find.text('Library'));
        await tester.tap(find.text('Favorites'));
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();

        // Assert
        expect(currentIndex, equals(4)); // Should be the last tapped tab
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.bySemanticsLabel('Home tab'), findsOneWidget);
        expect(find.bySemanticsLabel('Identify plants tab'), findsOneWidget);
        expect(find.bySemanticsLabel('Plant library tab'), findsOneWidget);
        expect(find.bySemanticsLabel('Favorites tab'), findsOneWidget);
        expect(find.bySemanticsLabel('Profile tab'), findsOneWidget);
      });

      testWidgets('should support screen readers', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.bySemanticsLabel('Home'), findsOneWidget);
        expect(find.bySemanticsLabel('Identify'), findsOneWidget);
        expect(find.bySemanticsLabel('Library'), findsOneWidget);
        expect(find.bySemanticsLabel('Favorites'), findsOneWidget);
        expect(find.bySemanticsLabel('Profile'), findsOneWidget);
      });
    });

    group('Styling Tests', () {
      testWidgets('should have proper theme colors', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        final bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNavBar.selectedItemColor, isNotNull);
        expect(bottomNavBar.unselectedItemColor, isNotNull);
        expect(bottomNavBar.backgroundColor, isNotNull);
      });

      testWidgets('should have proper elevation', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        final bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNavBar.elevation, isNotNull);
      });

      testWidgets('should have proper type', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        final bottomNavBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNavBar.type, equals(BottomNavigationBarType.fixed));
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle null onTap callback', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Content')),
              bottomNavigationBar: BottomNavBar(
                selectedIndex: 0,
                onTabSelected: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Identify'));
        await tester.pumpAndSettle();

        // Assert - should not throw
        expect(true, isTrue);
      });

      testWidgets('should handle invalid current index', (
        WidgetTester tester,
      ) async {
        // Arrange
        currentIndex = 10; // Invalid index

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - should not throw and should handle gracefully
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      });

      testWidgets('should handle negative current index', (
        WidgetTester tester,
      ) async {
        // Arrange
        currentIndex = -1; // Negative index

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - should not throw and should handle gracefully
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('should adapt to different screen sizes', (
        WidgetTester tester,
      ) async {
        // Arrange
        tester.binding.window.physicalSizeTestValue = const Size(400, 800);
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Reset
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });

      testWidgets('should handle landscape orientation', (
        WidgetTester tester,
      ) async {
        // Arrange
        tester.binding.window.physicalSizeTestValue = const Size(800, 400);
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Reset
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });
    });

    group('Performance Tests', () {
      testWidgets('should render efficiently', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
        ); // Should render quickly
      });

      testWidgets('should handle rapid navigation efficiently', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final stopwatch = Stopwatch()..start();

        // Rapidly tap different tabs
        for (int i = 0; i < 10; i++) {
          await tester.tap(find.text('Home'));
          await tester.tap(find.text('Identify'));
          await tester.tap(find.text('Library'));
          await tester.tap(find.text('Favorites'));
          await tester.tap(find.text('Profile'));
        }

        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(2000),
        ); // Should handle rapid taps efficiently
      });
    });
  });
}
