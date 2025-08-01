import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:flutter/widgets.dart';
import 'package:verdex/services/connectivity_service.dart';
import 'package:verdex/services/offline_storage_service.dart';
import 'package:verdex/services/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Offline Functionality Integration Tests', () {
    late ConnectivityService connectivityService;
    late OfflineStorageService offlineStorage;
    late AuthService authService;

    setUp(() {
      connectivityService = ConnectivityService();
      offlineStorage = OfflineStorageService();
      authService = AuthService();
    });

    group('Connectivity Service Tests', () {
      test('should initialize connectivity service', () async {
        // Act
        await connectivityService.initialize();

        // Assert
        expect(connectivityService.isInitialized, isTrue);
      });

      test('should provide connectivity status', () {
        // Act
        final status = connectivityService.getConnectivityStatus();

        // Assert
        expect(status, isA<Map<String, dynamic>>());
        expect(status.containsKey('isConnected'), isTrue);
        expect(status.containsKey('isReachable'), isTrue);
        expect(status.containsKey('isInitialized'), isTrue);
      });
    });

    group('Offline Storage Tests', () {
      test('should cache and retrieve user data', () async {
        // Arrange
        final userData = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
        };

        // Act
        await offlineStorage.cacheUserData(userData);
        final retrievedData = await offlineStorage.getCachedUserData();

        // Assert
        expect(retrievedData, isNotNull);
        expect(retrievedData!['id'], equals(1));
        expect(retrievedData!['name'], equals('Test User'));
        expect(retrievedData!['email'], equals('test@example.com'));
      });

      test('should cache and retrieve credentials', () async {
        // Arrange
        const login = 'test@example.com';
        const password = 'password';

        // Act
        await offlineStorage.cacheUserCredentials(login, password);
        final credentials = await offlineStorage.getCachedCredentials();

        // Assert
        expect(credentials, isNotNull);
        expect(credentials!['login'], equals(login));
        expect(credentials!['password'], equals(password));
        expect(credentials!.containsKey('timestamp'), isTrue);
      });

      test('should validate cached credentials', () async {
        // Arrange
        const login = 'test@example.com';
        const password = 'password';
        await offlineStorage.cacheUserCredentials(login, password);

        // Act
        final isValid = await offlineStorage.areCachedCredentialsValid();

        // Assert
        expect(isValid, isTrue);
      });

      test('should clear cached data', () async {
        // Arrange
        final userData = {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
        };
        await offlineStorage.cacheUserData(userData);
        await offlineStorage.cacheUserCredentials(
          'test@example.com',
          'password',
        );

        // Act
        await offlineStorage.clearAllCachedData();
        final retrievedUserData = await offlineStorage.getCachedUserData();
        final retrievedCredentials = await offlineStorage
            .getCachedCredentials();

        // Assert
        expect(retrievedUserData, isNull);
        expect(retrievedCredentials, isNull);
      });
    });

    group('Authentication Service Tests', () {
      test('should check authentication status', () async {
        // Act
        final isAuthenticated = await authService.isAuthenticated();

        // Assert
        expect(isAuthenticated, isA<bool>());
      });

      test('should check offline login availability', () async {
        // Act
        final isAvailable = await authService.isOfflineLoginAvailable();

        // Assert
        expect(isAvailable, isA<bool>());
      });

      test('should check offline mode status', () async {
        // Act
        final isOffline = await authService.isOfflineMode();

        // Assert
        expect(isOffline, isA<bool>());
      });
    });

    group('Integration Tests', () {
      test('should handle offline mode workflow', () async {
        // Arrange
        const login = 'test@example.com';
        const password = 'password';
        final userData = {'id': 1, 'name': 'Test User', 'email': login};

        // Act - Cache data for offline use
        await offlineStorage.cacheUserCredentials(login, password);
        await offlineStorage.cacheUserData(userData);
        await offlineStorage.setOfflineMode(true);

        // Assert - Verify offline mode is active
        final isOffline = await offlineStorage.isOfflineMode();
        expect(isOffline, isTrue);

        // Act - Check if offline login is available
        final isAvailable = await authService.isOfflineLoginAvailable();
        expect(isAvailable, isTrue);

        // Act - Clear offline mode
        await offlineStorage.setOfflineMode(false);
        final isOnline = await offlineStorage.isOfflineMode();
        expect(isOnline, isFalse);
      });

      test('should validate cache integrity', () async {
        // Arrange
        const login = 'test@example.com';
        const password = 'password';
        final userData = {'id': 1, 'name': 'Test User', 'email': login};

        // Act
        await offlineStorage.cacheUserCredentials(login, password);
        await offlineStorage.cacheUserData(userData);
        final isValid = await offlineStorage.validateCacheIntegrity();

        // Assert
        expect(isValid, isTrue);
      });
    });
  });
}
