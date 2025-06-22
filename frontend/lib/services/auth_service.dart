import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/api_config.dart';

class AuthService {
  // --- Simulated Methods for Frontend Prototyping ---

  Future<String?> login(String email, String password) async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@test.com' && password == 'password') {
      const token = 'dummy_token';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return token;
    }
    return null;
  }

  Future<String?> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));
    const token = 'dummy_token';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    return token;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  // --- API Methods for Laravel Backend ---

  Future<http.Response> loginWithApi(String email, String password) {
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }

  Future<http.Response> signupWithApi({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return http.post(
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
  }

  Future<http.Response> logoutWithApi(String token) {
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}/logout'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }
} 