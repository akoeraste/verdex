import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onTabSelected;
  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              height: 60,
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
                  _NavIcon(
                    icon: Icons.camera_alt_rounded,
                    selected: selectedIndex == 1,
                    onTap: () => onTabSelected(1),
                    size: 28,
                  ),
                  const SizedBox(width: 78),
                  _NavIcon(
                    icon: Icons.settings_rounded,
                    selected: selectedIndex == 2,
                    onTap: () => onTabSelected(2),
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
              onTap: () => onTabSelected(0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.10 * 255).toInt()),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.home_rounded,
                  size: 40,
                  color:
                      selectedIndex == 0
                          ? const Color(0xFF4CAF50)
                          : Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
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
