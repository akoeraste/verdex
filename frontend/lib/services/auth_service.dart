import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:async';
import '../constants/api_config.dart';
import 'connectivity_service.dart';
import 'offline_storage_service.dart';

class AuthService {
  static const _tokenKey = 'access_token';
  final FlutterSecureStorage _secureStorage;
  static Map<String, dynamic>? _currentUser;

  final ConnectivityService _connectivityService;
  final OfflineStorageService _offlineStorage;
  final http.Client _httpClient;

  AuthService({
    FlutterSecureStorage? secureStorage,
    ConnectivityService? connectivityService,
    OfflineStorageService? offlineStorage,
    http.Client? httpClient,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _connectivityService = connectivityService ?? ConnectivityService(),
       _offlineStorage = offlineStorage ?? OfflineStorageService(),
       _httpClient = httpClient ?? http.Client();

  // Get cached user info
  static Map<String, dynamic>? get currentUser => _currentUser;

  // Refresh user info from backend and cache it
  Future<Map<String, dynamic>?> refreshUser() async {
    final token = await getToken();
    if (token == null) return null;

    print(
      '🔐 [AuthService] Refreshing user data - Connection status: ${_connectivityService.isConnected ? "ONLINE" : "OFFLINE"}',
    );

    // Always try online first
    try {
      print('🔐 [AuthService] Attempting online user data fetch...');
      final response = await _httpClient
          .get(
            Uri.parse('${ApiConfig.baseUrl}/user'),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data is Map<String, dynamic>) {
            // If wrapped in {data: {...}}, unwrap
            final user = data['data'] ?? data;
            _currentUser = user is Map<String, dynamic> ? user : null;

            // Cache user data for offline use
            if (_currentUser != null) {
              await _offlineStorage.cacheUserData(_currentUser!);
              print(
                '🔐 [AuthService] User data fetched from server and cached successfully',
              );
            }

            return _currentUser;
          }
        } catch (_) {}
      }
      print(
        '🔐 [AuthService] Online user data fetch failed with status: ${response.statusCode}',
      );
    } catch (e) {
      print('🔐 [AuthService] Online refresh failed: $e');
      // Only fall back to cache if online request fails
      print('🔐 [AuthService] Falling back to cached user data...');
      final cachedUser = await _offlineStorage.getCachedUserData();
      if (cachedUser != null) {
        _currentUser = cachedUser;
        print('🔐 [AuthService] Using cached user data');
        return _currentUser;
      } else {
        print('🔐 [AuthService] No cached user data available');
      }
    }
    return null;
  }

  // Login and store token securely, then fetch and cache user info
  Future<Map<String, dynamic>> login(String login, String password) async {
    print(
      '🔐 [AuthService] Login attempt - Connection status: ${_connectivityService.isConnected ? "ONLINE" : "OFFLINE"}',
    );

    // Always try online first if we have connectivity
    if (_connectivityService.isConnected) {
      print('🔐 [AuthService] Attempting online login...');
      try {
        final response = await _httpClient
            .post(
              Uri.parse('${ApiConfig.baseUrl}/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
              },
              body: jsonEncode(<String, String>{
                'login': login,
                'password': password,
              }),
            )
            .timeout(const Duration(seconds: 15));

        print(
          '🔐 [AuthService] Login response: status=${response.statusCode}, body=${response.body}',
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['access_token'];
          if (token != null) {
            await _secureStorage.write(key: _tokenKey, value: token);

            // Cache credentials for offline login
            await _offlineStorage.cacheUserCredentials(login, password);
            print(
              '🔐 [AuthService] Online login successful, credentials cached',
            );

            // Fetch and cache user info after login
            await refreshUser();
            return {
              'success': true,
              'usedTempPass': data['used_temp_pass'] ?? false,
              'offline': false,
            };
          }
        }

        // If online login fails, return error
        print(
          '🔐 [AuthService] Online login failed with status: ${response.statusCode}',
        );
        return {'success': false, 'usedTempPass': false, 'offline': false};
      } catch (e) {
        print('🔐 [AuthService] Online login failed: $e');
        // Only fall back to offline login if online completely fails
        print('🔐 [AuthService] Falling back to offline login...');
        return await _offlineLogin(login, password);
      }
    } else {
      // No connectivity, try offline login
      print('🔐 [AuthService] No connectivity, attempting offline login...');
      return await _offlineLogin(login, password);
    }
  }

  // Offline login using cached credentials (only used as fallback)
  Future<Map<String, dynamic>> _offlineLogin(
    String login,
    String password,
  ) async {
    print('🔐 [AuthService] Checking cached credentials...');

    // Check if we have cached credentials
    final cachedCredentials = await _offlineStorage.getCachedCredentials();
    if (cachedCredentials == null) {
      print('🔐 [AuthService] No cached credentials found');
      return {
        'success': false,
        'message':
            'No cached credentials found. Please connect to the internet and login first to enable offline access.',
        'offline': true,
      };
    }

    // Check if credentials match
    if (cachedCredentials['login'] != login ||
        cachedCredentials['password'] != password) {
      print('🔐 [AuthService] Cached credentials do not match');
      return {
        'success': false,
        'message':
            'Invalid credentials. Please connect to the internet to verify your login.',
        'offline': true,
      };
    }

    // Check if cached credentials are still valid
    final areValid = await _offlineStorage.areCachedCredentialsValid();
    if (!areValid) {
      print('🔐 [AuthService] Cached credentials have expired');
      return {
        'success': false,
        'message':
            'Cached credentials have expired. Please connect to the internet to login.',
        'offline': true,
      };
    }

    // Get cached user data
    final cachedUser = await _offlineStorage.getCachedUserData();
    if (cachedUser == null) {
      print('🔐 [AuthService] No cached user data found');
      return {
        'success': false,
        'message':
            'No cached user data found. Please connect to the internet to login.',
        'offline': true,
      };
    }

    // Set current user from cache
    _currentUser = cachedUser;

    // Set offline mode
    await _offlineStorage.setOfflineMode(true);

    print('🔐 [AuthService] Offline login successful using cached data');
    return {
      'success': true,
      'usedTempPass': false,
      'offline': true,
      'message':
          'Logged in using cached credentials. Connect to the internet to sync your data.',
    };
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Initialize user data on app startup
  Future<void> initializeUser() async {
    print('🔐 [AuthService] Initializing user data...');
    if (_currentUser == null) {
      final token = await getToken();
      if (token != null) {
        // Use cached data first for faster startup, then refresh in background
        print('🔐 [AuthService] Token found, checking cached data first...');
        final cachedUser = await _offlineStorage.getCachedUserData();
        if (cachedUser != null) {
          _currentUser = cachedUser;
          print(
            '🔐 [AuthService] Using cached user data for immediate startup',
          );
        }

        // Refresh from server in background (non-blocking)
        _refreshUserInBackground();
      } else {
        // Check if we have valid cached credentials for offline login
        print(
          '🔐 [AuthService] No token found, checking cached credentials...',
        );
        final cachedCredentials = await _offlineStorage.getCachedCredentials();
        if (cachedCredentials != null) {
          final areValid = await _offlineStorage.areCachedCredentialsValid();
          if (areValid) {
            print(
              '🔐 [AuthService] Valid cached credentials available for offline login',
            );
            // Try to get cached user data
            final cachedUser = await _offlineStorage.getCachedUserData();
            if (cachedUser != null) {
              _currentUser = cachedUser;
              print(
                '🔐 [AuthService] Loaded cached user data for offline mode',
              );
            }
          } else {
            print('🔐 [AuthService] Cached credentials have expired');
            // Clear expired credentials
            await _offlineStorage.clearAllCachedData();
          }
        } else {
          print('🔐 [AuthService] No cached credentials available');
        }
      }
    }
  }

  // Refresh user data in background without blocking the UI
  Future<void> _refreshUserInBackground() async {
    try {
      print('🔐 [AuthService] Refreshing user data in background...');
      await refreshUser();
      print('🔐 [AuthService] Background refresh completed');
    } catch (e) {
      print('🔐 [AuthService] Background refresh failed: $e');
    }
  }

  // Logout and remove token
  Future<void> logout() async {
    print('🔐 [AuthService] Logging out...');
    final token = await getToken();
    print(
      '🔐 [AuthService] Logout - Current token: ${token != null ? "EXISTS" : "NULL"}',
    );

    try {
      if (token != null && _connectivityService.isConnected) {
        print('🔐 [AuthService] Attempting online logout...');
        await _httpClient
            .post(
              Uri.parse('${ApiConfig.baseUrl}/logout'),
              headers: <String, String>{
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 10));
        print('🔐 [AuthService] Online logout successful');
      }
    } catch (e) {
      // Ignore errors, always clear token
      print('🔐 [AuthService] Logout error: $e');
    }

    // Clear token and current user
    await _secureStorage.delete(key: _tokenKey);
    _currentUser = null;
    print('🔐 [AuthService] Logout - Token and current user cleared');

    // Clear all cached data including credentials for complete logout
    await _offlineStorage.clearAllCachedData();
    print('🔐 [AuthService] Logout - All cached data cleared');

    // Clear offline mode
    await _offlineStorage.setOfflineMode(false);
    print('🔐 [AuthService] Logout complete');
  }

  // Enhanced authentication check with better offline support
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    print(
      '🔐 [AuthService] isAuthenticated - Token: ${token != null ? "EXISTS" : "NULL"}',
    );

    if (token != null) {
      print('🔐 [AuthService] isAuthenticated - Returning true (token exists)');
      return true;
    }

    // For offline mode, we need both valid cached credentials AND cached user data
    final cachedCredentials = await _offlineStorage.getCachedCredentials();
    print(
      '🔐 [AuthService] isAuthenticated - Cached credentials: ${cachedCredentials != null ? "EXISTS" : "NULL"}',
    );

    if (cachedCredentials != null) {
      final areValid = await _offlineStorage.areCachedCredentialsValid();
      print('🔐 [AuthService] isAuthenticated - Credentials valid: $areValid');

      if (areValid) {
        // Also check if we have cached user data
        final cachedUser = await _offlineStorage.getCachedUserData();
        print(
          '🔐 [AuthService] isAuthenticated - Cached user data: ${cachedUser != null ? "EXISTS" : "NULL"}',
        );

        if (cachedUser != null) {
          // Set current user for offline mode
          _currentUser = cachedUser;
          return true;
        }
      } else {
        // Clear expired credentials
        await _offlineStorage.clearAllCachedData();
      }
    }

    print(
      '🔐 [AuthService] isAuthenticated - Returning false (no valid authentication)',
    );
    return false;
  }

  // Enhanced sync when coming back online with better error handling
  Future<void> syncWhenOnline() async {
    if (!_connectivityService.isConnected ||
        !_connectivityService.isReachable) {
      print('🔐 [AuthService] Not connected or not reachable, skipping sync');
      return;
    }

    print('🔐 [AuthService] Syncing when back online...');
    final token = await getToken();
    if (token != null) {
      try {
        // Refresh user data from server
        await refreshUser();

        // Process pending actions
        await _processPendingActions();

        // Clear offline mode
        await _offlineStorage.setOfflineMode(false);
        print('🔐 [AuthService] Sync complete');
      } catch (e) {
        print('🔐 [AuthService] Sync failed: $e');
        // Don't clear offline mode if sync failed
      }
    } else {
      print('🔐 [AuthService] No token available for sync');
    }
  }

  // Process pending actions that were queued while offline
  Future<void> _processPendingActions() async {
    final pendingActions = await _offlineStorage.getPendingActions();

    if (pendingActions.isNotEmpty) {
      print(
        '🔐 [AuthService] Processing ${pendingActions.length} pending actions...',
      );
    }

    for (final action in pendingActions) {
      try {
        switch (action['action']) {
          case 'update_profile':
            // Handle profile update sync
            break;
          case 'change_password':
            // Handle password change sync
            break;
          // Add more action types as needed
        }
      } catch (e) {
        // Log error but continue with other actions
        print('🔐 [AuthService] Error processing pending action: $e');
      }
    }

    // Clear processed actions
    await _offlineStorage.clearPendingActions();
    print('🔐 [AuthService] Pending actions processed');
  }

  // Example: Authenticated GET request
  Future<http.Response?> getAuthenticated(String endpoint) async {
    final token = await getToken();
    if (token == null) return null;
    return _httpClient.get(
      Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  // Signup/register method
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (!_connectivityService.isConnected) {
      throw Exception('Internet connection required for registration');
    }

    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'name': name,
            'email': email,
            'password': password,
            'password_confirmation': passwordConfirmation,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // Password reset method (send temp password)
  Future<bool> sendTempPassword(String email) async {
    if (!_connectivityService.isConnected) {
      throw Exception('Internet connection required for password reset');
    }

    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/send-temp-password'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
          body: jsonEncode(<String, String>{'email': email}),
        )
        .timeout(const Duration(seconds: 15));

    return response.statusCode == 200;
  }

  // Update user profile (with optional avatar upload)
  Future<Map<String, dynamic>> updateProfile({
    String? username, // now optional
    String? email, // now optional
    String? avatarPath, // Local file path
  }) async {
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'message': 'Not authenticated'};
    }

    if (!_connectivityService.isConnected) {
      // Queue for sync when online
      await _offlineStorage.addPendingAction('update_profile', {
        'username': username,
        'email': email,
        'avatarPath': avatarPath,
      });

      return {
        'success': true,
        'message': 'Profile update queued for sync when online',
        'offline': true,
      };
    }

    var uri = Uri.parse('${ApiConfig.baseUrl}/user');
    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    if (avatarPath != null && avatarPath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('avatar', avatarPath),
      );
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {'success': false, 'message': response.body};
    }
  }

  // Change user password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'message': 'Not authenticated'};
    }

    if (!_connectivityService.isConnected) {
      // Queue for sync when online
      await _offlineStorage.addPendingAction('change_password', {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'newPasswordConfirmation': newPasswordConfirmation,
      });

      return {
        'success': true,
        'message': 'Password change queued for sync when online',
        'offline': true,
      };
    }

    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/profile/change-password'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'current_password': currentPassword,
            'new_password': newPassword,
            'new_password_confirmation': newPasswordConfirmation,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Password changed successfully'};
    } else {
      String message = 'Failed to change password';
      try {
        final data = jsonDecode(response.body);
        if (data is Map && data['message'] != null) {
          message = data['message'];
        }
      } catch (_) {}
      return {'success': false, 'message': message};
    }
  }

  // Fetch current user info (from cache if available, otherwise from backend)
  Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    return await refreshUser();
  }

  // Check if currently in offline mode
  Future<bool> isOfflineMode() async {
    return await _offlineStorage.isOfflineMode();
  }

  // Check if offline login is available (has valid cached credentials and user data)
  Future<bool> isOfflineLoginAvailable() async {
    final cachedCredentials = await _offlineStorage.getCachedCredentials();
    if (cachedCredentials == null) return false;

    final areValid = await _offlineStorage.areCachedCredentialsValid();
    if (!areValid) return false;

    final cachedUser = await _offlineStorage.getCachedUserData();
    return cachedUser != null;
  }

  // Force logout with complete data clearing
  Future<void> forceLogout() async {
    print('🔐 [AuthService] Force logging out...');

    // Clear token and current user
    await _secureStorage.delete(key: _tokenKey);
    _currentUser = null;
    print('🔐 [AuthService] Force logout - Token and current user cleared');

    // Clear all cached data including credentials for complete logout
    await _offlineStorage.clearAllCachedData();
    print('🔐 [AuthService] Force logout - All cached data cleared');

    // Clear offline mode
    await _offlineStorage.setOfflineMode(false);
    print('🔐 [AuthService] Force logout complete');
  }
}
