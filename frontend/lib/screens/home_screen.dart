import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../widgets/educational_snippet.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_actions.dart';
import '../services/language_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _quickActionsAnimationController;
  late AnimationController _educationalAnimationController;
  late AnimationController _bounceAnimationController;

  late Animation<double> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _quickActionsSlideAnimation;
  late Animation<double> _quickActionsScaleAnimation;
  late Animation<double> _educationalSlideAnimation;
  late Animation<double> _educationalFadeAnimation;
  late Animation<double> _bounceAnimation;

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _quickActionsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _educationalAnimationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _bounceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Header animations
    _headerSlideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Quick actions animations
    _quickActionsSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _quickActionsAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _quickActionsScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _quickActionsAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Educational snippet animations
    _educationalSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _educationalAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _educationalFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _educationalAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Bounce animation for interactive elements
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _bounceAnimationController,
        curve: Curves.elasticInOut,
      ),
    );

    // Start animations with staggered timing
    _startAnimations();
  }

  void _startAnimations() async {
    if (!mounted || _isDisposed) return;

    // Start header animation
    if (!_isDisposed) {
      _headerAnimationController.forward();
    }

    // Start quick actions animation after a delay
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted || _isDisposed) return;
    if (!_isDisposed) {
      _quickActionsAnimationController.forward();
    }

    // Start educational snippet animation after another delay
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted || _isDisposed) return;
    if (!_isDisposed) {
      _educationalAnimationController.forward();
    }

    // Start continuous bounce animation
    if (!mounted || _isDisposed) return;
    if (!_isDisposed) {
      _bounceAnimationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _headerAnimationController.dispose();
    _quickActionsAnimationController.dispose();
    _educationalAnimationController.dispose();
    _bounceAnimationController.dispose();
    super.dispose();
  }

  void _showLanguageSelector() {
    final languageService = Provider.of<LanguageService>(
      context,
      listen: false,
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'select_language'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Full width language buttons
                  ...languageService.availableLanguages.map((lang) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildFullWidthLanguageButton(
                        lang,
                        languageService,
                        setModalState,
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFullWidthLanguageButton(
    Language lang,
    LanguageService service,
    StateSetter setModalState,
  ) {
    final isSelected =
        service.majorLanguageCode == lang.code &&
        service.minorLanguageCode == null;
    final hasMinor = lang.minorLanguages.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main language button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient:
                isSelected
                    ? const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color: isSelected ? null : const Color(0xFFF8F9FA),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await service.setLanguage(lang.code, minorCode: null);
                await context.setLocale(Locale(lang.code));
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        lang.name,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 16,
                          color:
                              isSelected
                                  ? Colors.white
                                  : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Minor languages if any
        if (hasMinor)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Column(
              children:
                  lang.minorLanguages.map((minorLang) {
                    final isMinorSelected =
                        service.minorLanguageCode == minorLang.code;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              isMinorSelected
                                  ? const Color(0xFF667EEA)
                                  : const Color(0xFFF1F3F4),
                          boxShadow:
                              isMinorSelected
                                  ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF667EEA,
                                      ).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              await service.setLanguage(
                                lang.code,
                                minorCode: minorLang.code,
                              );
                              await context.setLocale(Locale(lang.code));
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      minorLang.name,
                                      style: TextStyle(
                                        fontWeight:
                                            isMinorSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                        fontSize: 14,
                                        color:
                                            isMinorSelected
                                                ? Colors.white
                                                : const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                  ),
                                  if (isMinorSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Animated Header
                AnimatedBuilder(
                  animation: _headerAnimationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _headerSlideAnimation.value),
                      child: Opacity(
                        opacity: _headerFadeAnimation.value,
                        child: HomeHeader(
                          onLanguageButtonPressed: _showLanguageSelector,
                          quickActions: AnimatedBuilder(
                            animation: _quickActionsAnimationController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  _quickActionsSlideAnimation.value,
                                ),
                                child: Transform.scale(
                                  scale: _quickActionsScaleAnimation.value,
                                  child: const QuickActions(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          // Animated Educational Snippet
                          AnimatedBuilder(
                            animation: _educationalAnimationController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  _educationalSlideAnimation.value,
                                ),
                                child: Opacity(
                                  opacity: _educationalFadeAnimation.value,
                                  child: AnimatedBuilder(
                                    animation: _bounceAnimationController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _bounceAnimation.value,
                                        child: const EducationalSnippet(),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
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
