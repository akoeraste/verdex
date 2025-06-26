import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:verdex/screens/welcome_screen.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  // Call this before showing the screen to check if it should be shown
  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('permissions_screen_shown') ?? false);
  }

  // Call this after showing the screen to mark it as shown
  static Future<void> markShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permissions_screen_shown', true);
  }

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _requested = false;

  Future<void> _grantPermissionsAndContinue() async {
    setState(() {
      _requested = true;
    });
    final permissions = [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ];
    final statusMap = await permissions.request();
    final anyPermanentlyDenied = statusMap.values.any(
      (status) => status.isPermanentlyDenied,
    );
    await PermissionScreen.markShown();
    if (anyPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Some permissions are permanently denied. Please enable them in app settings.',
            ),
          ),
        );
        await openAppSettings();
      }
    } else {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() async {
    final user = AuthService.currentUser;
    final hasUsername =
        user != null && (user['username']?.toString().isNotEmpty ?? false);
    if (mounted) {
      if (hasUsername) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBE7),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),
            Icon(Icons.shield_outlined, size: 80, color: Colors.green[800]),
            const SizedBox(height: 30),
            Text(
              'permissions_title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'permissionsRequiredBody'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const Spacer(flex: 3),
            ElevatedButton(
              onPressed: _requested ? null : _grantPermissionsAndContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                'continue'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
