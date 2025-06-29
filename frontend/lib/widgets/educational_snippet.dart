import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class EducationalSnippet extends StatefulWidget {
  const EducationalSnippet({super.key});

  @override
  State<EducationalSnippet> createState() => _EducationalSnippetState();
}

class _EducationalSnippetState extends State<EducationalSnippet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoSwipeTimer;

  final List<_Fact> _facts = [
    _Fact(
      title: 'did_you_know'.tr(),
      text: 'tomato_fact'.tr(),
      image: 'assets/images/tomato.png',
    ),
    _Fact(
      title: 'did_you_know'.tr(),
      text: 'banana_fact'.tr(),
      image: 'assets/images/banana.png',
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index % _facts.length;
    });
    // Reset timer when page changes
    _startAutoSwipeTimer();
  }

  void _handleLooping() {
    final int pageCount = _facts.length;
    if (!_pageController.hasClients) return;
    int page = _pageController.page?.round() ?? 0;
    if (page >= pageCount * 2) {
      _pageController.jumpToPage(page % pageCount + pageCount);
    } else if (page < pageCount) {
      _pageController.jumpToPage(page + pageCount);
    }
  }

  void _startAutoSwipeTimer() {
    _autoSwipeTimer?.cancel();
    _autoSwipeTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && _pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_facts.length);
      _startAutoSwipeTimer();
    });
    _pageController.addListener(() {
      if (!_pageController.position.isScrollingNotifier.value) {
        _handleLooping();
      }
    });
  }

  @override
  void dispose() {
    _autoSwipeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'did_you_know'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _facts.length * 1000, // large for infinite effect
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final fact = _facts[index % _facts.length];
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          fact.text,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x1A000000),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              fact.image,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_facts.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient:
                        _currentPage == i
                            ? const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : null,
                    color: _currentPage == i ? null : const Color(0xFFE5E7EB),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact {
  final String title;
  final String text;
  final String image;
  const _Fact({required this.title, required this.text, required this.image});
}
