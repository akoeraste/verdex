import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:verdex/screens/home_screen.dart';
import 'package:verdex/screens/identify_screen.dart';
import 'package:verdex/screens/settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const IdentifyScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      // Modern Floating Bottom Navigation Bar
      bottomNavigationBar: SizedBox(
        height: 130,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Floating bar background
            Positioned(
              bottom: 20,
              left: 32,
              right: 32,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Search Icon (left)
                    _NavIcon(
                      icon: Icons.camera_alt_rounded,
                      selected: _selectedIndex == 1,
                      onTap: () => _onItemTapped(1),
                      size: 28,
                    ),
                    // Spacer for center icon
                    const SizedBox(width: 78),
                    // Settings Icon (right)
                    _NavIcon(
                      icon: Icons.settings_rounded,
                      selected: _selectedIndex == 2,
                      onTap: () => _onItemTapped(2),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            // Center Home Icon (floating above bar)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _onItemTapped(0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color:
                        _selectedIndex == 0
                            ? const Color(0xFF4CAF50)
                            : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color:
                          _selectedIndex == 0
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade200,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    size: 40,
                    color:
                        _selectedIndex == 0
                            ? Colors.white
                            : const Color(0xFF4CAF50),
                  ),
                ),
              ),
            ),
          ],
        ),
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
