import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:verdex/screens/home_screen.dart';
import 'package:verdex/screens/identify_screen.dart';
import 'package:verdex/screens/settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const IdentifyScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authService = AuthService();
    final user = AuthService.currentUser;
    final hasUsername =
        user != null && (user['username']?.toString().isNotEmpty ?? false);

    if (!hasUsername && mounted) {
      await authService.logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final double size;
  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              selected
                  ? const Color(0xFF4CAF50).withOpacity(0.12)
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: size,
          color: selected ? const Color(0xFF4CAF50) : Colors.grey.shade500,
        ),
      ),
    );
  }
}
