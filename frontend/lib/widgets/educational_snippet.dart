import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EducationalSnippet extends StatefulWidget {
  const EducationalSnippet({super.key});

  @override
  State<EducationalSnippet> createState() => _EducationalSnippetState();
}

class _EducationalSnippetState extends State<EducationalSnippet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
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
    _Fact(
      title: 'did_you_know'.tr(),
      text: 'apple_fact'.tr(),
      image: 'assets/images/apple.png',
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index % _facts.length;
    });
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_facts.length);
    });
    _pageController.addListener(() {
      if (!_pageController.position.isScrollingNotifier.value) {
        _handleLooping();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF1F8E9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 90,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _facts.length * 1000, // large for infinite effect
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final fact = _facts[index % _facts.length];
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fact.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fact.text,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Image.asset(fact.image, height: 80),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_facts.length, (i) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPage == i
                            ? const Color(0xFF4CAF50)
                            : Colors.grey[400],
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
