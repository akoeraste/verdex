# Verdex App Test Suite

This directory contains a comprehensive test suite for the Verdex Flutter application. The tests are organized into different categories to ensure thorough coverage of all app functionality.

## Test Structure

```
test/
├── services/                    # Service layer unit tests
│   ├── auth_service_test.dart
│   ├── plant_service_test.dart
│   ├── connectivity_service_test.dart
│   └── apple_classifier_service_test.dart
├── screens/                     # Screen widget tests
│   ├── login_screen_test.dart
│   └── home_screen_test.dart
├── widgets/                     # Reusable widget tests
│   ├── plant_card_test.dart
│   └── bottom_nav_bar_test.dart
├── integration/                 # End-to-end integration tests
│   └── app_flow_test.dart
├── unit/                        # Utility and helper tests
│   └── utils_test.dart
├── performance/                 # Performance and benchmark tests
│   └── performance_test.dart
├── security/                    # Security and data protection tests
│   └── security_test.dart
├── accessibility/               # Accessibility compliance tests
│   └── accessibility_test.dart
├── run_tests.dart              # Test runner script
└── README.md                   # This file
```

## Test Categories

### 1. Unit Tests (`services/`, `unit/`)
- **Purpose**: Test individual functions and classes in isolation
- **Coverage**: Service layer, utility functions, data processing
- **Examples**: Authentication logic, plant data fetching, input validation

### 2. Widget Tests (`screens/`, `widgets/`)
- **Purpose**: Test UI components and user interactions
- **Coverage**: Screen rendering, form validation, navigation
- **Examples**: Login form, plant cards, navigation bar

### 3. Integration Tests (`integration/`)
- **Purpose**: Test complete user workflows and app flows
- **Coverage**: End-to-end scenarios, cross-screen interactions
- **Examples**: Complete login flow, plant identification process

### 4. Performance Tests (`performance/`)
- **Purpose**: Ensure app meets performance benchmarks
- **Coverage**: Loading times, memory usage, responsiveness
- **Examples**: App startup time, data loading performance

### 5. Security Tests (`security/`)
- **Purpose**: Verify security best practices and data protection
- **Coverage**: Authentication, encryption, input validation
- **Examples**: Password security, data encryption, SQL injection prevention

### 6. Accessibility Tests (`accessibility/`)
- **Purpose**: Ensure app is accessible to users with disabilities
- **Coverage**: Screen reader support, keyboard navigation, color contrast
- **Examples**: Semantic labels, focus management, touch target sizes

## Running Tests

### Prerequisites
1. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

2. Generate mock files (if needed):
   ```bash
   flutter packages pub run build_runner build
   ```

### Running All Tests
```bash
# Run all tests
flutter test

# Run with verbose output
flutter test --verbose

# Run with coverage report
flutter test --coverage
```

### Running Specific Test Categories
```bash
# Run only unit tests
flutter test test/services/
flutter test test/unit/

# Run only widget tests
flutter test test/screens/
flutter test test/widgets/

# Run only integration tests
flutter test test/integration/

# Run only performance tests
flutter test test/performance/

# Run only security tests
flutter test test/security/

# Run only accessibility tests
flutter test test/accessibility/
```

### Running Individual Test Files
```bash
# Run specific test file
flutter test test/services/auth_service_test.dart

# Run with specific test name
flutter test --name "should login successfully"
```

### Using the Test Runner
```bash
# Run the comprehensive test suite
dart test/run_tests.dart
```

## Test Configuration

### Environment Variables
The tests use the following environment variables:
- `FLUTTER_TEST`: Set to 'true' during test execution
- `TEST_TIMEOUT`: Timeout duration for tests (default: 30 seconds)
- `VERBOSE_LOGGING`: Enable detailed logging (default: true)
- `PERFORMANCE_MONITORING`: Enable performance tracking (default: true)

### Test Dependencies
The following packages are used for testing:
- `flutter_test`: Core Flutter testing framework
- `mockito`: Mocking framework for unit tests
- `build_runner`: Code generation for mocks
- `http_mock_adapter`: HTTP request mocking
- `test`: Dart testing framework
- `integration_test`: Flutter integration testing

## Writing Tests

### Unit Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:verdex/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    test('should login successfully with valid credentials', () async {
      // Arrange
      final authService = AuthService();
      
      // Act
      final result = await authService.login('test@example.com', 'password');
      
      // Assert
      expect(result['success'], isTrue);
    });
  });
}
```

### Widget Test Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verdex/screens/login_screen.dart';

void main() {
  testWidgets('should render login form', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    
    // Act
    await tester.pumpAndSettle();
    
    // Assert
    expect(find.byType(TextField), findsAtLeast(2));
    expect(find.byType(ElevatedButton), findsOne);
  });
}
```

### Integration Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:verdex/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete login flow', (WidgetTester tester) async {
    // Arrange
    app.main();
    await tester.pumpAndSettle();
    
    // Act
    await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password_field')), 'password');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    
    // Assert
    expect(find.text('Home'), findsOne);
  });
}
```

## Test Best Practices

### 1. Test Organization
- Use descriptive test names that explain the expected behavior
- Group related tests using `group()`
- Follow the Arrange-Act-Assert pattern
- Keep tests independent and isolated

### 2. Mocking
- Mock external dependencies (APIs, databases, services)
- Use `@GenerateMocks()` annotation for automatic mock generation
- Verify that mocks are called with expected parameters

### 3. Assertions
- Use specific assertions that test the exact behavior
- Test both positive and negative cases
- Verify error handling and edge cases
- Check for side effects when appropriate

### 4. Performance
- Keep tests fast and efficient
- Use `setUp()` and `tearDown()` for common operations
- Avoid unnecessary async operations in tests
- Use timeouts for long-running operations

### 5. Coverage
- Aim for high test coverage (80%+)
- Focus on critical business logic
- Test error conditions and edge cases
- Include integration tests for key user flows

## Continuous Integration

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.7.2'
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter test test/integration/
```

### Test Reports
The test suite generates comprehensive reports including:
- Test execution summary
- Coverage metrics
- Performance benchmarks
- Security compliance status
- Accessibility audit results

## Troubleshooting

### Common Issues

1. **Mock Generation Errors**
   ```bash
   # Regenerate mocks
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Test Timeout Issues**
   - Increase timeout in test configuration
   - Check for infinite loops or blocking operations
   - Use `tester.pumpAndSettle()` for async operations

3. **Platform-Specific Issues**
   - Run tests on specific platforms: `flutter test -d chrome`
   - Check platform-specific dependencies
   - Use conditional imports for platform-specific code

4. **Integration Test Issues**
   - Ensure device/emulator is available
   - Check app permissions and configurations
   - Verify test environment setup

### Debugging Tests
```bash
# Run tests with debug output
flutter test --verbose

# Run specific test with debugging
flutter test --name "specific test name" --verbose

# Run tests with observatory
flutter test --start-paused
```

## Contributing

When adding new features or modifying existing code:

1. **Write tests first** (TDD approach)
2. **Update existing tests** if functionality changes
3. **Add integration tests** for new user flows
4. **Update this README** if test structure changes
5. **Ensure all tests pass** before submitting PR

## Test Metrics

The test suite tracks the following metrics:
- **Test Coverage**: Percentage of code covered by tests
- **Test Execution Time**: Time taken to run all tests
- **Test Reliability**: Percentage of tests that pass consistently
- **Performance Benchmarks**: App performance under various conditions
- **Security Score**: Compliance with security best practices
- **Accessibility Score**: Compliance with accessibility standards

## Support

For questions or issues with the test suite:
1. Check the troubleshooting section above
2. Review Flutter testing documentation
3. Create an issue in the project repository
4. Contact the development team 