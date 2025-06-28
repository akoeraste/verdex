import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';
import 'onboarding_screen.dart';
import 'main_screen.dart';
import 'permission_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool permissionsGranted;
  const SplashScreen({super.key, required this.permissionsGranted});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    debugPrint('Splash: Starting initialization');
    try {
      // Reduced delay for faster loading
      await Future.delayed(const Duration(milliseconds: 500));

      // Run initialization tasks in parallel for better performance
      final results = await Future.wait([
        _checkAuthenticationStatus(),
        _loadPreferences(),
      ]);

      final isAuthenticated = results[0] as bool;
      final prefs = results[1] as Map<String, bool>;

      final onboardingCompleted = prefs['onboarding_completed'] ?? false;
      final permissionsScreenShown = prefs['permissions_screen_shown'] ?? false;

      debugPrint('Splash: User authenticated? $isAuthenticated');
      debugPrint('Splash: Onboarding completed? $onboardingCompleted');

      if (mounted) {
        if (!isAuthenticated) {
          debugPrint(
            'Splash: User not authenticated, redirecting to WelcomeScreen',
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        } else if (!onboardingCompleted) {
          debugPrint('Splash: Navigating to OnboardingScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        } else if (!permissionsScreenShown) {
          debugPrint('Splash: Navigating to PermissionScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PermissionScreen()),
          );
        } else {
          debugPrint('Splash: Navigating to MainScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      }
    } catch (e, stack) {
      debugPrint('Splash: Error during initialization: $e');
      debugPrint(stack.toString());
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    debugPrint('Splash: Checking authentication status...');

    // Don't call initializeUser here as it might set current user incorrectly
    // Just check authentication status directly
    final authService = AuthService();
    final isAuthenticated = await authService.isAuthenticated();

    debugPrint('Splash: Authentication result: $isAuthenticated');
    return isAuthenticated;
  }

  Future<Map<String, bool>> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'onboarding_completed': prefs.getBool('onboarding_completed') ?? false,
      'permissions_screen_shown':
          prefs.getBool('permissions_screen_shown') ?? false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              right: -150,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Main content
            Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo container with modern styling
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // App name
                    Text(
                      'app_name'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Loading indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'loading'.tr(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
