import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _loginError;
  String? _passwordError;
  String? _generalError;
  bool _isLoading = false;
  bool _obscurePassword = true;
  final FocusNode _loginFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    await _connectivityService.initialize();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _loginFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _loginError = null;
      _passwordError = null;
      _generalError = null;
    });

    final login = _loginController.text.trim();
    final password = _passwordController.text;
    bool valid = true;

    if (login.isEmpty) {
      setState(() => _loginError = 'login_error_empty'.tr());
      valid = false;
    }
    if (password.isEmpty) {
      setState(() => _passwordError = 'password_error_empty'.tr());
      valid = false;
    }
    if (!valid) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Refresh connectivity status before login
      await _connectivityService.refreshConnectivity();

      // Use AuthService for login (handles both online and offline)
      final authService = AuthService();

      // Add timeout to prevent infinite loading
      final result = await authService
          .login(login, password)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException(
                'Login timeout',
                const Duration(seconds: 30),
              );
            },
          );

      if (result['success'] == true) {
        if (mounted) {
          setState(() => _isLoading = false);

          // Show offline message if applicable
          if (result['offline'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Logged in offline'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 4),
              ),
            );
          }

          if (result['usedTempPass'] == true) {
            Navigator.of(context).pushReplacementNamed('/change-password');
          } else {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        }
      } else {
        setState(() {
          _isLoading = false;
          _generalError = result['message'] ?? 'invalid_credentials'.tr();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        if (e is TimeoutException) {
          _generalError =
              'Login timeout. Please check your internet connection and try again.';
        } else {
          _generalError =
              'Network error. Please check your connection and try again.';
        }
      });

      // Log the error for debugging
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Aurora Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF9FBE7), Color(0xFFE8F5E9)],
              ),
            ),
          ),
          // Blurred circles
          Positioned(
            top: -100,
            left: -100,
            child: _buildBlurCircle(Colors.green.shade200),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: _buildBlurCircle(Colors.green.shade400),
          ),
          SafeArea(
            child: Column(
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF212121)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Header
                          Text(
                            'welcome_back'.tr(),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'login_to_account'.tr(),
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Glassmorphic Form Card
                          _buildGlassmorphicCard(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _loginController,
                                    focusNode: _loginFocus,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      _loginFocus.unfocus();
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_passwordFocus);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'login_field_label'.tr(),
                                      labelStyle: GoogleFonts.poppins(
                                        color: Colors.grey.shade800,
                                      ),
                                      floatingLabelStyle: GoogleFonts.poppins(
                                        color: const Color(0xFF2E7D32),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person_outline,
                                        color: Colors.grey.shade600,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withAlpha(
                                        (0.5 * 255).toInt(),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF4CAF50),
                                        ),
                                      ),
                                      errorText: _loginError,
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: const Color(0xFF212121),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) {
                                      _passwordFocus.unfocus();
                                      if (!_isLoading) {
                                        _login();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'password_field_label'.tr(),
                                      labelStyle: GoogleFonts.poppins(
                                        color: Colors.grey.shade800,
                                      ),
                                      floatingLabelStyle: GoogleFonts.poppins(
                                        color: const Color(0xFF2E7D32),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Colors.grey.shade600,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey.shade600,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withAlpha(
                                        (0.5 * 255).toInt(),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF4CAF50),
                                        ),
                                      ),
                                      errorText: _passwordError,
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: const Color(0xFF212121),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Error message
                                  if (_generalError != null)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.red.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red.shade600,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _generalError!,
                                              style: GoogleFonts.poppins(
                                                color: Colors.red.shade700,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: 24),
                                  // Login button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF4CAF50,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child:
                                          _isLoading
                                              ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              )
                                              : Text(
                                                'login_button'.tr(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Forgot password link
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/forgot-password',
                                      );
                                    },
                                    child: Text(
                                      'forgot_password'.tr(),
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF4CAF50),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'dont_have_account'.tr(),
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                child: Text(
                                  'sign_up'.tr(),
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF4CAF50),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildBlurCircle(Color color) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.3),
      ),
    );
  }
}
