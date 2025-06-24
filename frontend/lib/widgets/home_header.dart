import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final Function onLanguageButtonPressed;
  final bool showGreeting;
  final bool showSearchBar;

  const HomeHeader({
    super.key,
    required this.onLanguageButtonPressed,
    this.showGreeting = true,
    this.showSearchBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Text(
                'Verdex',
                style: TextStyle(
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
          if (showGreeting) ...[
            const SizedBox(height: 16),
            // Dynamic greeting message
            Text(
              'greeting_message'.tr(args: ['Renny']),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (showSearchBar) ...[
            const SizedBox(height: 20),

            // Rounded search bar
            GestureDetector(
              onTap: () {
                // Pending: Open full search screen
                print('Search bar tapped - open search screen');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
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
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
