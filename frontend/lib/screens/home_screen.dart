import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../widgets/educational_snippet.dart';
import '../widgets/home_header.dart';
import '../widgets/recently_identified_list.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBE7),
      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(onLanguageButtonPressed: _showLanguageSelector),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const EducationalSnippet(),
                    const SizedBox(height: 24),
                    SectionHeader(title: 'recent_searches'.tr()),
                    const SizedBox(height: 16),
                    const RecentlyIdentifiedList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
