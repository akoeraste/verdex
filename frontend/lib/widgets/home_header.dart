import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/plant_library_screen.dart';

class HomeHeader extends StatelessWidget {
  final Function onLanguageButtonPressed;
  final bool showGreeting;
  final bool showSearchBar;
  final Widget? quickActions;

  const HomeHeader({
    super.key,
    required this.onLanguageButtonPressed,
    this.showGreeting = true,
    this.showSearchBar = true,
    this.quickActions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main header container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFF9FBE7),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Top row with language selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App name instead of leaf icon
                  Text(
                    'app_name'.tr(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                      fontFamily: 'Poppins',
                      letterSpacing: 1.2,
                    ),
                  ),
                  // Language selector
                  IconButton(
                    onPressed: () => onLanguageButtonPressed(),
                    icon: const Icon(
                      Icons.language,
                      color: Color(0xFF4CAF50),
                      size: 28,
                    ),
                  ),
                ],
              ),
              if (showSearchBar) ...[
                const SizedBox(height: 20),
                // Rounded search bar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlantLibraryScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(
                          0xFF4CAF50,
                        ).withAlpha((0.3 * 255).toInt()),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).toInt()),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Color(0xFF4CAF50),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'search_placeholder'.tr(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Quick actions section with white background spanning edge to edge
        if (quickActions != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color.fromARGB(18, 255, 255, 255),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(1),
                bottomRight: Radius.circular(1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'hi'.tr()} ${AuthService.currentUser?['username'] ?? AuthService.currentUser?['name'] ?? 'User'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),
                Text(
                  'greeting_message'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2E7D32),
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 36),
                quickActions!,
              ],
            ),
          ),
      ],
    );
  }
}
