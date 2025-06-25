import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:verdex/screens/welcome_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  Future<void> _requestPermissions() async {
    final statusMap = await [Permission.camera, Permission.photos].request();
    final allGranted = statusMap.values.every((status) => status.isGranted);
    if (allGranted) {
      _navigateToNextScreen();
    } else {
      final anyPermanentlyDenied = statusMap.values.any(
        (status) => status.isPermanentlyDenied,
      );
      if (anyPermanentlyDenied) {
        _showPermissionDialog(permanentlyDenied: true);
      } else {
        _showPermissionDialog(permanentlyDenied: false);
      }
    }
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  void _showPermissionDialog({required bool permanentlyDenied}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('permissions_dialog_title'.tr()),
            content: Text(
              permanentlyDenied
                  ? 'permissions_dialog_permanently_denied'.tr()
                  : 'permissions_dialog_denied'.tr(),
            ),
            actions: [
              if (permanentlyDenied)
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: Text('permissions_dialog_open_settings'.tr()),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ok'.tr()),
              ),
            ],
          ),
    );
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
              'permissions_subtitle'.tr(),
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
              onPressed: _requestPermissions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                'permissions_button'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _navigateToNextScreen,
              child: Text(
                'permissions_skip'.tr(),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
