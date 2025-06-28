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
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 120,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Floating bar background
            Positioned(
              bottom: 20,
              left: 32,
              right: 32,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1A000000),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: const Color(0x0A000000),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    const SizedBox(width: 78),
                    _NavIcon(
                      icon: Icons.settings_rounded,
                      selected: selectedIndex == 2,
                      onTap: () => onTabSelected(2),
                      size: 28,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Center Home Icon (floating above bar)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => onTabSelected(0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient:
                        selectedIndex == 0
                            ? const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : null,
                    color: selectedIndex == 0 ? null : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            selectedIndex == 0
                                ? const Color(0xFF667EEA).withOpacity(0.3)
                                : const Color(0x1A000000),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                      if (selectedIndex == 0)
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    size: 36,
                    color:
                        selectedIndex == 0
                            ? Colors.white
                            : const Color(0xFF6B7280),
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
  final Gradient gradient;

  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
    this.size = 28,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: selected ? gradient : null,
          color: selected ? null : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Icon(
          icon,
          size: size,
          color: selected ? Colors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
