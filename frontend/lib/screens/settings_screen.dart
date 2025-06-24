import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'identify_screen.dart';
import 'favorites_screen.dart';
import 'feedback_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';
import 'about_us_screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  final int _sectionCount = 4; // Number of sections to animate

  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _sectionCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 450),
        vsync: this,
      ),
    );

    _runAnimations();

    _fetchAppVersionFromPubspec();
  }

  void _runAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 + (i * 100)), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  Future<void> _fetchAppVersionFromPubspec() async {
    try {
      final yamlString = await rootBundle.loadString('pubspec.yaml');
      final versionLine = yamlString
          .split('\n')
          .firstWhere((line) => line.trim().startsWith('version:'));
      final version = versionLine.split(':').last.trim().split('+').first;
      setState(() {
        _appVersion = 'v$version';
      });
    } catch (e) {
      setState(() {
        _appVersion = '';
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _selectedLanguage = 'english'.tr();
  String _selectedTheme = 'light'.tr();
  bool _isDarkMode = false;
  bool _enableSound = true;
  bool _wifiOnly = true;
  final AuthService _authService = AuthService();

  void _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
    }
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'select_language'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLanguageOption(
                  'english'.tr(),
                  '🇺🇸',
                  const Locale('en'),
                ),
                _buildLanguageOption('french'.tr(), '🇫🇷', const Locale('fr')),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildLanguageOption(String name, String flag, Locale locale) {
    final isSelected = context.locale == locale;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
        ),
      ),
      trailing:
          isSelected ? const Icon(Icons.check, color: Color(0xFF4CAF50)) : null,
      onTap: () {
        context.setLocale(locale);
        setState(() {
          _selectedLanguage = name;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'select_theme'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 20),
                _buildThemeOption('light'.tr(), Icons.wb_sunny_outlined),
                _buildThemeOption('dark'.tr(), Icons.nightlight_round),
                _buildThemeOption('system_default'.tr(), Icons.settings),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildThemeOption(String name, IconData icon) {
    final isSelected = _selectedTheme == name;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF4CAF50) : Colors.black54,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
        ),
      ),
      trailing:
          isSelected ? const Icon(Icons.check, color: Color(0xFF4CAF50)) : null,
      onTap: () {
        setState(() {
          _selectedTheme = name;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBE7),
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Header (now scrolls with content)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(
                          'settings'.tr(),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E7D32),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 🔝 Top Section: Profile Summary
                  _buildAnimatedSection(
                    index: 0,
                    child: _buildProfileSection(),
                  ),
                  const SizedBox(height: 24),
                  // 🟢 Section 2: Quick Access
                  _buildAnimatedSection(
                    index: 1,
                    child: _buildQuickAccessSection(),
                  ),
                  const SizedBox(height: 24),
                  // 🟩 Section 3: Preferences
                  _buildAnimatedSection(
                    index: 2,
                    child: _buildPreferencesSection(),
                  ),
                  const SizedBox(height: 24),
                  // ⚪ Section 4: About
                  _buildAnimatedSection(index: 3, child: _buildAboutSection()),
                  const SizedBox(
                    height: 80,
                  ), // Add space so content doesn't hide behind version
                ],
              ),
            ),
            // Fixed app version at the bottom
            if (_appVersion.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: Center(
                  child: Text(
                    'Version: $_appVersion',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({required int index, required Widget child}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeOutCubic,
        ),
      ),
      child: FadeTransition(opacity: _controllers[index], child: child),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Circular avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'R',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Renny',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'renny@example.com',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Edit Profile button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'edit_profile'.tr(),
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Change Password and Logout
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF4CAF50),
                    ),
                    title: Text('change_password'.tr()),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'logout'.tr(),
                      style: TextStyle(color: Colors.red),
                    ),
                    contentPadding: EdgeInsets.zero,
                    onTap: _logout,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('quick_access'.tr()),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildQuickAccessItem(
                icon: Icons.camera_alt,
                title: 'identify_plant'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const IdentifyScreen()),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildQuickAccessItem(
                icon: Icons.favorite,
                title: 'my_favorites'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildQuickAccessItem(
                icon: Icons.comment,
                title: 'give_feedback'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('app_preferences'.tr()),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Language
              ListTile(
                leading: const Icon(Icons.language, color: Color(0xFF4CAF50)),
                title: Text('language'.tr()),
                subtitle: Text(_selectedLanguage),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showLanguageSelector,
              ),
              const Divider(height: 1, indent: 56),
              // Theme Mode
              ListTile(
                leading: const Icon(
                  Icons.brightness_6,
                  color: Color(0xFF4CAF50),
                ),
                title: Text('theme_mode'.tr()),
                subtitle: Text(_selectedTheme),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showThemeSelector,
              ),
              const Divider(height: 1, indent: 56),
              // Enable Sound
              ListTile(
                leading: const Icon(Icons.volume_up, color: Color(0xFF4CAF50)),
                title: Text('enable_sound'.tr()),
                trailing: Switch(
                  value: _enableSound,
                  onChanged: (value) {
                    setState(() {
                      _enableSound = value;
                    });
                  },
                  activeColor: const Color(0xFF4CAF50),
                  inactiveThumbColor: Colors.grey[300],
                  inactiveTrackColor: Colors.grey[200],
                ),
              ),
              const Divider(height: 1, indent: 56),
              // Download over Wi-Fi only
              ListTile(
                leading: const Icon(Icons.wifi, color: Color(0xFF4CAF50)),
                title: Text('download_wifi_only'.tr()),
                trailing: Switch(
                  value: _wifiOnly,
                  onChanged: (value) {
                    setState(() {
                      _wifiOnly = value;
                    });
                  },
                  activeColor: const Color(0xFF4CAF50),
                  inactiveThumbColor: Colors.grey[300],
                  inactiveTrackColor: Colors.grey[200],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('about_verdex'.tr()),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF4CAF50),
                ),
                title: Text('about_us'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(
                  Icons.privacy_tip_outlined,
                  color: Color(0xFF4CAF50),
                ),
                title: Text('privacy_policy'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF4CAF50),
                ),
                title: Text('terms_of_service'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TermsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2E7D32),
      ),
    );
  }

  Widget _buildQuickAccessItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4CAF50)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
