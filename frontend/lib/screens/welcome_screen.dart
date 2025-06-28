import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    final loggedIn = await authService.isLoggedIn();
    if (loggedIn && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _showLanguageSelector(BuildContext context) {
    final languageService = Provider.of<LanguageService>(
      context,
      listen: false,
    );
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'select_language'.tr(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        languageService.availableLanguages.map((lang) {
                          return _buildLanguageButton(
                            context,
                            lang,
                            languageService,
                            setModalState,
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    Language lang,
    LanguageService service,
    StateSetter setModalState,
  ) {
    final isSelected =
        service.majorLanguageCode == lang.code &&
        service.minorLanguageCode == null;
    final hasMinor = lang.minorLanguages.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: isSelected ? 4 : 0,
          ),
          onPressed: () async {
            await service.setLanguage(lang.code, minorCode: null);
            await context.setLocale(Locale(lang.code));
            Navigator.pop(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.check, size: 18, color: Colors.white),
                ),
            ],
          ),
        ),
        if (hasMinor)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 6.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  lang.minorLanguages.map((minorLang) {
                    final isMinorSelected =
                        service.minorLanguageCode == minorLang.code;
                    return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            isMinorSelected
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                        foregroundColor:
                            isMinorSelected ? Colors.white : Colors.black87,
                        side: BorderSide(
                          color:
                              isMinorSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[400]!,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        await service.setLanguage(
                          lang.code,
                          minorCode: minorLang.code,
                        );
                        await context.setLocale(Locale(lang.code));
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            minorLang.name,
                            style: TextStyle(
                              fontWeight:
                                  isMinorSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          if (isMinorSelected)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF9FBE7), Color(0xFFE8F5E9)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Language toggler at top right
              Positioned(
                top: 0,
                right: 30,
                child: IconButton(
                  icon: const Icon(
                    Icons.language,
                    color: Color(0xFF4CAF50),
                    size: 28,
                  ),
                  onPressed: () => _showLanguageSelector(context),
                ),
              ),
              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 16.0,
                ),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                    // Logo, app name, tagline
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
                    const SizedBox(height: 36),
                    // Login/Signup buttons
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Social icons and continue with text at the bottom
                    FadeInUp(
                      duration: const Duration(milliseconds: 1500),
                      delay: const Duration(milliseconds: 400),
                      child: Column(
                        children: [
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
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
