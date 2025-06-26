import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../constants/api_config.dart';

class AuthService {
  static const _tokenKey = 'access_token';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static Map<String, dynamic>? _currentUser;

  // Get cached user info
  static Map<String, dynamic>? get currentUser => _currentUser;

  // Refresh user info from backend and cache it
  Future<Map<String, dynamic>?> refreshUser() async {
    final token = await getToken();
    if (token == null) return null;
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/user'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          // If wrapped in {data: {...}}, unwrap
          final user = data['data'] ?? data;
          _currentUser = user is Map<String, dynamic> ? user : null;
          return _currentUser;
        }
      } catch (_) {}
    }
    return null;
  }

  // Login and store token securely, then fetch and cache user info
  Future<Map<String, dynamic>> login(String login, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{'login': login, 'password': password}),
    );

    print(
      'LOGIN RESPONSE: status=${response.statusCode}, body=${response.body}',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      if (token != null) {
        await _secureStorage.write(key: _tokenKey, value: token);
        // Fetch and cache user info after login
        await refreshUser();
        return {
          'success': true,
          'usedTempPass': data['used_temp_pass'] ?? false,
        };
      }
    }
    return {'success': false, 'usedTempPass': false};
  }

  // Check if user is logged in (token exists)
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null;
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Initialize user data on app startup
  Future<void> initializeUser() async {
    if (_currentUser == null) {
      final token = await getToken();
      if (token != null) {
        await refreshUser();
      }
    }
  }

  // Logout and remove token
  Future<void> logout() async {
    final token = await getToken();
    try {
      if (token != null) {
        await http.post(
          Uri.parse('${ApiConfig.baseUrl}/logout'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      }
    } catch (e) {
      // Ignore errors, always clear token
    }
    await _secureStorage.delete(key: _tokenKey);
    _currentUser = null;
  }

  // Example: Authenticated GET request
  Future<http.Response?> getAuthenticated(String endpoint) async {
    final token = await getToken();
    if (token == null) return null;
    return http.get(
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
    final response = await http.post(
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
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // Password reset method (send temp password)
  Future<bool> sendTempPassword(String email) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/send-temp-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );
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
    final response = await http.post(
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
    );
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

  // You can add signup and other methods as needed, similar to above
}
