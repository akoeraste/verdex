import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OfflineStorageService {
  static final OfflineStorageService _instance =
      OfflineStorageService._internal();
  factory OfflineStorageService() => _instance;
  OfflineStorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Cache for frequently accessed data
  Map<String, dynamic>? _cachedUserData;
  Map<String, dynamic>? _cachedCredentials;
  bool _userDataLoaded = false;
  bool _credentialsLoaded = false;

  // Keys for secure storage
  static const String _cachedCredentialsKey = 'cached_credentials';
  static const String _cachedUserDataKey = 'cached_user_data';
  static const String _lastSyncTimestampKey = 'last_sync_timestamp';
  static const String _pendingActionsKey = 'pending_actions';

  // Keys for shared preferences
  static const String _isOfflineModeKey = 'is_offline_mode';
  static const String _offlineModeEnabledKey = 'offline_mode_enabled';

  // Cache user credentials for offline login
  Future<void> cacheUserCredentials(String login, String password) async {
    final credentials = {
      'login': login,
      'password': password,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _cachedCredentials = credentials; // Update cache
    _credentialsLoaded = true;

    await _secureStorage.write(
      key: _cachedCredentialsKey,
      value: jsonEncode(credentials),
    );
  }

  // Get cached user credentials
  Future<Map<String, dynamic>?> getCachedCredentials() async {
    if (_credentialsLoaded && _cachedCredentials != null) {
      return _cachedCredentials;
    }

    final credentialsJson = await _secureStorage.read(
      key: _cachedCredentialsKey,
    );
    if (credentialsJson != null) {
      try {
        _cachedCredentials =
            jsonDecode(credentialsJson) as Map<String, dynamic>;
        _credentialsLoaded = true;
        return _cachedCredentials;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Cache user data
  Future<void> cacheUserData(Map<String, dynamic> userData) async {
    _cachedUserData = userData; // Update cache
    _userDataLoaded = true;

    await _secureStorage.write(
      key: _cachedUserDataKey,
      value: jsonEncode(userData),
    );
    await _setLastSyncTimestamp();
  }

  // Get cached user data
  Future<Map<String, dynamic>?> getCachedUserData() async {
    if (_userDataLoaded && _cachedUserData != null) {
      return _cachedUserData;
    }

    final userDataJson = await _secureStorage.read(key: _cachedUserDataKey);
    if (userDataJson != null) {
      try {
        _cachedUserData = jsonDecode(userDataJson) as Map<String, dynamic>;
        _userDataLoaded = true;
        return _cachedUserData;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Set last sync timestamp
  Future<void> _setLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _lastSyncTimestampKey,
      DateTime.now().toIso8601String(),
    );
  }

  // Get last sync timestamp
  Future<DateTime?> getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(_lastSyncTimestampKey);
    if (timestamp != null) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Check if offline mode is enabled
  Future<bool> isOfflineModeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_offlineModeEnabledKey) ?? false;
  }

  // Enable/disable offline mode
  Future<void> setOfflineModeEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_offlineModeEnabledKey, enabled);
  }

  // Set current offline mode status
  Future<void> setOfflineMode(bool isOffline) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOfflineModeKey, isOffline);
  }

  // Get current offline mode status
  Future<bool> isOfflineMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isOfflineModeKey) ?? false;
  }

  // Add pending action for sync when online
  Future<void> addPendingAction(
    String action,
    Map<String, dynamic> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingActions = prefs.getStringList(_pendingActionsKey) ?? [];

    final actionData = {
      'action': action,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };

    pendingActions.add(jsonEncode(actionData));
    await prefs.setStringList(_pendingActionsKey, pendingActions);
  }

  // Get pending actions
  Future<List<Map<String, dynamic>>> getPendingActions() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingActions = prefs.getStringList(_pendingActionsKey) ?? [];

    return pendingActions
        .map((actionJson) {
          try {
            return jsonDecode(actionJson) as Map<String, dynamic>;
          } catch (e) {
            return <String, dynamic>{};
          }
        })
        .where((action) => action.isNotEmpty)
        .toList();
  }

  // Clear pending actions
  Future<void> clearPendingActions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingActionsKey);
  }

  // Clear all cached data
  Future<void> clearAllCachedData() async {
    print('🗄️ [OfflineStorage] Clearing all cached data...');

    await _secureStorage.delete(key: _cachedCredentialsKey);
    await _secureStorage.delete(key: _cachedUserDataKey);
    print('🗄️ [OfflineStorage] Secure storage cleared');

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSyncTimestampKey);
    await prefs.remove(_pendingActionsKey);
    await prefs.remove(_isOfflineModeKey);
    await prefs.remove(_offlineModeEnabledKey);
    print('🗄️ [OfflineStorage] Shared preferences cleared');

    // Clear in-memory cache
    _cachedUserData = null;
    _cachedCredentials = null;
    _userDataLoaded = false;
    _credentialsLoaded = false;
    print('🗄️ [OfflineStorage] In-memory cache cleared');

    print('🗄️ [OfflineStorage] All cached data cleared successfully');
  }

  // Clear only cached user data (keep credentials for offline login)
  Future<void> clearCachedUserData() async {
    await _secureStorage.delete(key: _cachedUserDataKey);
    _cachedUserData = null;
    _userDataLoaded = false;
  }

  // Check if cached credentials are still valid (within 30 days)
  Future<bool> areCachedCredentialsValid() async {
    final credentials = await getCachedCredentials();
    if (credentials == null) return false;

    final timestamp = DateTime.tryParse(credentials['timestamp'] ?? '');
    if (timestamp == null) return false;

    final daysSinceCached = DateTime.now().difference(timestamp).inDays;
    return daysSinceCached <= 30; // Valid for 30 days
  }
}
