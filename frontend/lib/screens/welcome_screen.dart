import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Enhanced background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF9FBE7), // Soft leaf white
              Color(0xFFE8F5E9), // Lighter green tint
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo/Icon
                  FadeInDown(
                    duration: const Duration(milliseconds: 1200),
                    child: Spin(
                      duration: const Duration(milliseconds: 2500),
                      delay: const Duration(milliseconds: 1200),
                      child: const Icon(
                        Icons.eco,
                        size: 80,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Animated App Name
                  FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: Text(
                      'app_name'.tr(),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                        fontSize: 42,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Animated Tagline
                  FadeInUp(
                    duration: const Duration(milliseconds: 1400),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'app_tagline'.tr(),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF212121),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Animated Buttons & Socials
                  FadeInUp(
                    duration: const Duration(milliseconds: 1500),
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              elevation: 2,
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            child: Text('login'.tr()),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF4CAF50),
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFF4CAF50),
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            child: Text('signup'.tr()),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'or_continue_with'.tr(),
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SocialIconButton(
                              icon: FontAwesomeIcons.google,
                              color: const Color(0xFFDB4437),
                              onTap: () {},
                            ),
                            const SizedBox(width: 24),
                            _SocialIconButton(
                              icon: FontAwesomeIcons.facebookF,
                              color: const Color(0xFF4267B2),
                              onTap: () {},
                            ),
                            const SizedBox(width: 24),
                            _SocialIconButton(
                              icon: FontAwesomeIcons.xTwitter,
                              color: const Color(0xFF000000),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SocialIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black.withAlpha((0.1 * 255).toInt()),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(child: FaIcon(icon, color: color, size: 24)),
        ),
      ),
    );
  }
}
