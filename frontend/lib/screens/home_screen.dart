import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../widgets/educational_snippet.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_actions.dart';
import '../widgets/section_header.dart';
import '../services/language_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              child: SingleChildScrollView(
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

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9FBE7),
          body: SafeArea(
            child: Column(
              children: [
                HomeHeader(
                  onLanguageButtonPressed: _showLanguageSelector,
                  quickActions: const QuickActions(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const EducationalSnippet(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
