import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import '../services/auth_service.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'permission_screen.dart';
import 'package:easy_localization/easy_localization.dart';
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
    print('Splash: Starting initialization');
    try {
      await Future.delayed(const Duration(seconds: 2));

      // Initialize user data from token
      await AuthService().initializeUser();
      final user = AuthService.currentUser;
      final hasUsername =
          user != null && (user['username']?.toString().isNotEmpty ?? false);

      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted =
          prefs.getBool('onboarding_completed') ?? false;
      final permissionsScreenShown =
          prefs.getBool('permissions_screen_shown') ?? false;
      print('Splash: Onboarding completed? $onboardingCompleted');
      if (mounted) {
        if (!hasUsername) {
          print('Splash: No valid user, redirecting to WelcomeScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        } else if (!onboardingCompleted) {
          print('Splash: Navigating to OnboardingScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        } else if (!permissionsScreenShown) {
          print('Splash: Navigating to PermissionScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PermissionScreen()),
          );
        } else {
          print('Splash: Navigating to MainScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      }
    } catch (e, stack) {
      print('Splash: Error during initialization: $e');
      print(stack);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
  }

  Future<Widget> _performInitialization() async {
    // This method is no longer needed, but kept for compatibility.
    return const PermissionScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F8E9), Color(0xFFA5D6A7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeIn(
            duration: const Duration(milliseconds: 1500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', width: 150),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
