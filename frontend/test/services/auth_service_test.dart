import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:verdex/services/auth_service.dart';
import 'package:verdex/services/connectivity_service.dart';
import 'package:verdex/services/offline_storage_service.dart';
import 'package:verdex/constants/api_config.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([
  ConnectivityService,
  OfflineStorageService,
  FlutterSecureStorage,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService Tests', () {
    late AuthService authService;
    late MockConnectivityService mockConnectivityService;
    late MockOfflineStorageService mockOfflineStorage;
    late MockFlutterSecureStorage mockSecureStorage;
    late MockClient mockHttpClient;

    setUp(() {
      mockConnectivityService = MockConnectivityService();
      mockOfflineStorage = MockOfflineStorageService();
      mockSecureStorage = MockFlutterSecureStorage();
      mockHttpClient = MockClient((request) async {
        // Default: return 400 for all requests unless overridden in test
        return http.Response('', 400);
      });
      authService = AuthService(
        secureStorage: mockSecureStorage,
        connectivityService: mockConnectivityService,
        offlineStorage: mockOfflineStorage,
        httpClient: mockHttpClient,
      );
    });

    group('Login Tests', () {
      test('should login successfully with valid credentials online', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(
          mockSecureStorage.write(
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});
        when(
          mockOfflineStorage.cacheUserCredentials(any, any),
        ).thenAnswer((_) async {});
        when(mockOfflineStorage.cacheUserData(any)).thenAnswer((_) async {});
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => 'test_token');
        final customHttpClient = MockClient((request) async {
          if (request.url.toString().contains('/login')) {
            return http.Response(
              '{"access_token": "test_token", "used_temp_pass": false}',
              200,
            );
          }
          if (request.url.toString().contains('/user')) {
            return http.Response(
              '{"data": {"id": 1, "name": "Test User", "email": "test@example.com"}}',
              200,
            );
          }
          return http.Response('Not found', 404);
        });
        authService = AuthService(
          secureStorage: mockSecureStorage,
          connectivityService: mockConnectivityService,
          offlineStorage: mockOfflineStorage,
          httpClient: customHttpClient,
        );
        // Act
        final result = await authService.login('test@example.com', 'password');
        // Assert
        expect(result['success'], isTrue);
        expect(result['usedTempPass'], isFalse);
        expect(result['offline'], isFalse);
      });

      test('should handle login failure with invalid credentials', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        final customHttpClient = MockClient((request) async {
          return http.Response('{"error": "Invalid credentials"}', 401);
        });
        authService = AuthService(
          secureStorage: mockSecureStorage,
          connectivityService: mockConnectivityService,
          offlineStorage: mockOfflineStorage,
          httpClient: customHttpClient,
        );
        // Act
        final result = await authService.login(
          'invalid@example.com',
          'wrongpassword',
        );
        // Assert
        expect(result['success'], isFalse);
        expect(result['offline'], isFalse);
      });

      test('should fallback to offline login when online fails', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(mockOfflineStorage.getCachedCredentials()).thenAnswer(
          (_) async => {'login': 'test@example.com', 'password': 'password'},
        );
        when(
          mockOfflineStorage.areCachedCredentialsValid(),
        ).thenAnswer((_) async => true);
        when(mockOfflineStorage.getCachedUserData()).thenAnswer(
          (_) async => {
            'id': 1,
            'name': 'Test User',
            'email': 'test@example.com',
          },
        );
        when(mockOfflineStorage.setOfflineMode(any)).thenAnswer((_) async {});
        final customHttpClient = MockClient((request) async {
          throw Exception('Network error');
        });
        authService = AuthService(
          secureStorage: mockSecureStorage,
          connectivityService: mockConnectivityService,
          offlineStorage: mockOfflineStorage,
          httpClient: customHttpClient,
        );
        // Act
        final result = await authService.login('test@example.com', 'password');
        // Assert
        expect(result['success'], isTrue);
        expect(result['offline'], isTrue);
      });

      test('should handle offline login with no cached credentials', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(false);
        when(
          mockOfflineStorage.getCachedCredentials(),
        ).thenAnswer((_) async => null);
        when(mockOfflineStorage.setOfflineMode(any)).thenAnswer((_) async {});
        // Act
        final result = await authService.login('test@example.com', 'password');
        // Assert
        expect(result['success'], isFalse);
        expect(result['offline'], isTrue);
        expect(result['message'], contains('No cached credentials found'));
      });
    });

    group('Token Management Tests', () {
      test('should store and retrieve token', () async {
        // Arrange
        const testToken = 'test_access_token';
        when(
          mockSecureStorage.write(
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => testToken);
        when(mockConnectivityService.isConnected).thenReturn(false);
        // Act
        await mockSecureStorage.write(key: 'access_token', value: testToken);
        final retrievedToken = await authService.getToken();
        // Assert
        expect(retrievedToken, equals(testToken));
      });

      test('should return null when no token is stored', () async {
        // Arrange
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => null);
        when(mockConnectivityService.isConnected).thenReturn(false);
        // Act
        final token = await authService.getToken();
        // Assert
        expect(token, isNull);
      });

      test('should clear token on logout', () async {
        // Arrange
        when(
          mockSecureStorage.delete(key: anyNamed('key')),
        ).thenAnswer((_) async {});
        when(mockOfflineStorage.clearAllCachedData()).thenAnswer((_) async {});
        when(mockOfflineStorage.setOfflineMode(any)).thenAnswer((_) async {});
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => null);
        when(mockConnectivityService.isConnected).thenReturn(false);
        // Act
        await authService.logout();
        final token = await authService.getToken();
        // Assert
        expect(token, isNull);
      });
    });

    group('User Management Tests', () {
      test('should refresh user data successfully', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => 'test_token');

        final mockClient = MockClient((request) async {
          return http.Response(
            '{"data": {"id": 1, "name": "Test User", "email": "test@example.com"}}',
            200,
          );
        });

        // Act
        final user = await authService.refreshUser();

        // Assert
        expect(user, isNotNull);
        expect(user!['id'], equals(1));
        expect(user['name'], equals('Test User'));
        expect(user['email'], equals('test@example.com'));
      });

      test(
        'should fallback to cached user data when online refresh fails',
        () async {
          // Arrange
          when(mockConnectivityService.isConnected).thenReturn(true);
          when(mockOfflineStorage.getCachedUserData()).thenAnswer(
            (_) async => {
              'id': 1,
              'name': 'Cached User',
              'email': 'cached@example.com',
            },
          );
          when(
            mockSecureStorage.read(key: anyNamed('key')),
          ).thenAnswer((_) async => 'test_token');

          final mockClient = MockClient((request) async {
            throw Exception('Network error');
          });

          // Act
          final user = await authService.refreshUser();

          // Assert
          expect(user, isNotNull);
          expect(user!['name'], equals('Cached User'));
        },
      );

      test('should return null when no user data available', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);
        when(
          mockOfflineStorage.getCachedUserData(),
        ).thenAnswer((_) async => null);
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => 'test_token');

        // Act
        final user = await authService.refreshUser();

        // Assert
        expect(user, isNull);
      });
    });

    group('Registration Tests', () {
      test('should register user successfully', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        final mockClient = MockClient((request) async {
          return http.Response(
            '{"message": "User registered successfully", "user": {"id": 1, "name": "New User"}}',
            201,
          );
        });

        // Act
        final result = await authService.signup(
          name: 'New User',
          email: 'newuser@example.com',
          password: 'password',
          passwordConfirmation: 'password',
        );

        // Assert
        expect(result, isTrue);
      });

      test('should handle registration failure', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        final mockClient = MockClient((request) async {
          return http.Response('{"error": "Email already exists"}', 422);
        });

        // Act
        final result = await authService.signup(
          name: 'Existing User',
          email: 'existing@example.com',
          password: 'password',
          passwordConfirmation: 'password',
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('Password Reset Tests', () {
      test('should send password reset email successfully', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        final mockClient = MockClient((request) async {
          return http.Response('{"message": "Password reset email sent"}', 200);
        });

        // Act
        final result = await authService.sendTempPassword('test@example.com');

        // Assert
        expect(result, isTrue);
      });

      test('should handle password reset failure', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        final mockClient = MockClient((request) async {
          return http.Response('{"error": "User not found"}', 404);
        });

        // Act
        final result = await authService.sendTempPassword(
          'nonexistent@example.com',
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('Authentication State Tests', () {
      test('should return true when user is authenticated', () async {
        // Arrange
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => 'valid_token');

        // Act
        final isAuthenticated = await authService.isAuthenticated();

        // Assert
        expect(isAuthenticated, isTrue);
      });

      test('should return false when user is not authenticated', () async {
        // Arrange
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => null);

        // Act
        final isAuthenticated = await authService.isAuthenticated();

        // Assert
        expect(isAuthenticated, isFalse);
      });
    });

    group('Error Handling Tests', () {
      test('should handle network timeout gracefully', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        final mockClient = MockClient((request) async {
          await Future.delayed(const Duration(seconds: 20));
          return http.Response('Timeout', 408);
        });

        // Act
        final result = await authService.login('test@example.com', 'password');

        // Assert
        expect(result['success'], isFalse);
      });

      test('should handle malformed JSON response', () async {
        // Arrange
        when(mockConnectivityService.isConnected).thenReturn(true);

        final mockClient = MockClient((request) async {
          return http.Response('Invalid JSON', 200);
        });

        // Act
        final result = await authService.login('test@example.com', 'password');

        // Assert
        expect(result['success'], isFalse);
      });
    });
  });
}
