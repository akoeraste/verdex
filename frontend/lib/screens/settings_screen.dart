import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'identify_screen.dart';
import 'favorites_screen.dart';
import 'feedback_screen.dart';
import 'notifications_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';
import 'about_us_screen.dart';
import '../screens/login_screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../widgets/section_header.dart';
import '../constants/api_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main_screen.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

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

  final AuthService _authService = AuthService();

  Map<String, dynamic>? get _userData => AuthService.currentUser;

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

  String _selectedLanguageKey = 'english';
  String _selectedThemeKey = 'light';
  bool _isDarkMode = false;
  bool _enableSound = true;
  bool _wifiOnly = true;

  void _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showLanguageSelector() {
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        languageService.availableLanguages.map((lang) {
                          return _buildLanguageButton(
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
    final isSelected = _selectedThemeKey.tr() == name;
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
          if (name == 'light'.tr()) {
            _selectedThemeKey = 'light';
          } else if (name == 'dark'.tr()) {
            _selectedThemeKey = 'dark';
          } else {
            _selectedThemeKey = 'system_default';
          }
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(bottom: 120),
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
                  const SizedBox(height: 80),
                ],
              ),
            ),
            // Fixed app version at the bottom
            if (_appVersion.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 100,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: _getUserAvatarUrl(),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          width: 60,
                          height: 60,
                          color: const Color(0xFF4CAF50),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          color: const Color(0xFF4CAF50),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            ),
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
                      Text(
                        _userData?['username'] ?? _userData?['name'] ?? '-',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userData?['email'] ?? '-',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Edit Profile button
                TextButton(
                  onPressed: _goToEditProfile,
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
                    onTap: _showLogoutDialog,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    await _authService.refreshUser();
    setState(() {}); // Refresh UI with new user info
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('quick_access'),
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => MainScreen(initialIndex: 1),
                    ),
                    (route) => false,
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
              const Divider(height: 1, indent: 56),
              _buildQuickAccessItem(
                icon: Icons.notifications,
                title: 'notifications'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
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
        _buildSectionHeader('app_preferences'),
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
                subtitle: Text(_selectedLanguageKey.tr()),
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
                subtitle: Text(_selectedThemeKey.tr()),
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
        _buildSectionHeader('about_verdex'),
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

  Widget _buildSectionHeader(String titleKey) {
    return SectionHeader(titleKey: titleKey);
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

  // Add this helper to get the user's avatar URL
  String _getUserAvatarUrl() {
    final avatar = _userData?['avatar'];
    if (avatar != null && avatar is String && avatar.isNotEmpty) {
      if (avatar.startsWith('http')) return avatar;
      final baseUrl = ApiConfig.baseUrl.replaceFirst('/api', '');
      return avatar.startsWith('/') ? baseUrl + avatar : baseUrl + '/' + avatar;
    }
    // fallback
    const avatarPath = '/storage/avatars/default.png';
    final baseUrl = ApiConfig.baseUrl.replaceFirst('/api', '');
    return baseUrl + avatarPath;
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'logout'.tr(),
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            content: Text(
              'logoutConfirmation'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _logout();
                },
                child: Text('ok'.tr()),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel'.tr()),
              ),
            ],
          ),
    );
  }
}
