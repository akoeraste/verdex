import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _nameError;
  String? _loginError;
  String? _passwordError;
  String? _confirmError;
  String? _generalError;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _signup() async {
    setState(() {
      _nameError = null;
      _loginError = null;
      _passwordError = null;
      _confirmError = null;
      _generalError = null;
    });
    final username = _nameController.text.trim();
    final email = _loginController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    bool valid = true;
    if (username.isEmpty) {
      setState(() => _nameError = 'usernameRequired'.tr());
      valid = false;
    } else if (username.length < 6) {
      setState(() => _nameError = 'usernameMinLength'.tr());
      valid = false;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _loginError = 'invalidEmail'.tr());
      valid = false;
    }
    if (password.isEmpty) {
      setState(() => _passwordError = 'passwordRequired'.tr());
      valid = false;
    } else if (password.length < 6) {
      setState(() => _passwordError = 'passwordMinLength'.tr());
      valid = false;
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      setState(() => _passwordError = 'passwordRequirements'.tr());
      valid = false;
    }
    if (confirm != password) {
      setState(() => _confirmError = 'passwords_do_not_match'.tr());
      valid = false;
    }
    if (!valid) {
      return;
    }
    setState(() => _isLoading = true);
    final authService = AuthService();
    final success = await authService.signup(
      name: username,
      email: email,
      password: password,
      passwordConfirmation: confirm,
    );
    setState(() => _isLoading = false);
    if (success) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'success'.tr(),
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                content: Text(
                  'registration_success_message'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Text('ok'.tr()),
                  ),
                ],
              ),
        );
      }
    } else {
      setState(() => _generalError = 'registrationFailed'.tr());
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
          Positioned(
            top: -100,
            right: -100,
            child: _buildBlurCircle(Colors.green.shade200),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: _buildBlurCircle(Colors.green.shade400),
          ),
          SafeArea(
            child: Column(
              children: [
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
                          const SizedBox(height: 20),
                          Text(
                            'create_account'.tr(),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'join_verdex_community'.tr(),
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildGlassmorphicCard(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'username'.tr(),
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
                                    errorText: _nameError,
                                  ),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: const Color(0xFF212121),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: _loginController,
                                  decoration: InputDecoration(
                                    labelText: 'email'.tr(),
                                    labelStyle: GoogleFonts.poppins(
                                      color: Colors.grey.shade800,
                                    ),
                                    floatingLabelStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF2E7D32),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.alternate_email,
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
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    labelText: 'password'.tr(),
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
                                          _obscurePassword = !_obscurePassword;
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
                                const SizedBox(height: 20),
                                TextField(
                                  controller: _confirmController,
                                  obscureText: _obscureConfirm,
                                  decoration: InputDecoration(
                                    labelText: 'confirm_new_password'.tr(),
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
                                        _obscureConfirm
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey.shade600,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirm = !_obscureConfirm;
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
                                    errorText: _confirmError,
                                  ),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: const Color(0xFF212121),
                                  ),
                                ),
                                if (_generalError != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    _generalError!,
                                    style: GoogleFonts.poppins(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 28),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _signup,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4CAF50),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.green.withAlpha(
                                        (0.4 * 255).toInt(),
                                      ),
                                      textStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    child:
                                        _isLoading
                                            ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                            : Text('signup'.tr()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed:
                                () => Navigator.of(
                                  context,
                                ).pushReplacementNamed('/login'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'already_have_account'.tr(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'login'.tr(),
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF2E7D32),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.3 * 255).toInt()),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withAlpha((0.4 * 255).toInt()),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildBlurCircle(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha((0.4 * 255).toInt()),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
