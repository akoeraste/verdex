import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:verdex/services/favorite_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/plant_service.dart';

class PlantDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> plant;

  const PlantDetailsScreen({super.key, required this.plant});

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen>
    with TickerProviderStateMixin {
  bool _isFavorite = false;
  bool _isPlayingAudio = false;
  bool _isFavoriteLoading = false;
  final FavoriteService _favoriteService = FavoriteService();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // For swipable image gallery
  List<String> _imageUrls = [];
  PageController _pageController = PageController();
  int _currentImageIndex = 0;

  late Map<String, dynamic> _plant;
  late LanguageService _languageService;
  late VoidCallback _languageListener;
  String? _lastLanguageCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _plant = widget.plant;
    _languageService = Provider.of<LanguageService>(context, listen: false);
    _languageListener = () {
      _fetchPlant();
    };
    _languageService.addListener(_languageListener);
    _fetchPlant();
    _loadFavoriteStatus();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) setState(() => _isPlayingAudio = false);
    });
    // Swipable images setup
    final dynamic images = widget.plant['image_urls'];
    if (images is List && images.isNotEmpty) {
      _imageUrls =
          images
              .map((img) {
                if (img is String) return img;
                if (img is Map && img.containsKey('url'))
                  return img['url'] as String;
                return img.toString();
              })
              .where((url) => url.isNotEmpty)
              .toList();
    } else if (widget.plant['image_url'] != null) {
      _imageUrls = [widget.plant['image_url']];
    } else {
      _imageUrls = [];
    }
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageService = Provider.of<LanguageService>(context);
    final currentLang = languageService.effectiveLanguageCode;
    if (_lastLanguageCode != currentLang) {
      _lastLanguageCode = currentLang;
      _fetchPlant();
    }
  }

  @override
  void dispose() {
    _languageService.removeListener(_languageListener);
    _fadeController.dispose();
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlant() async {
    setState(() {
      _isLoading = true;
    });
    final plantId = _plant['id'];
    if (plantId != null) {
      try {
        final plant = await PlantService().getPlantById(plantId);
        if (mounted && plant != null) {
          setState(() {
            _plant = plant;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to load plant: $e')));
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavoriteStatus() async {
    final plantId = _plant['id'];
    if (plantId != null) {
      try {
        final isFav = await _favoriteService.isFavorite(plantId);
        if (mounted) setState(() => _isFavorite = isFav);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to check favorite: $e')),
          );
        }
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final plantId = _plant['id'];
    if (plantId == null || _isFavoriteLoading) return;
    setState(() {
      _isFavoriteLoading = true;
      _isFavorite = !_isFavorite; // Optimistic update
    });
    try {
      if (_isFavorite) {
        await _favoriteService.addFavorite(plantId);
      } else {
        await _favoriteService.removeFavorite(plantId);
      }
    } catch (e) {
      setState(() {
        _isFavorite = !_isFavorite; // Revert on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'failedToUpdateFavorite'.tr(namedArgs: {'error': e.toString()}),
          ),
        ),
      );
    } finally {
      setState(() {
        _isFavoriteLoading = false;
      });
    }
  }

  Future<String> _getLocalAudioPath(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = url.split('/').last;
    final file = File('${dir.path}/$filename');
    if (await file.exists()) {
      return file.path;
    } else {
      await Dio().download(url, file.path);
      return file.path;
    }
  }

  Future<void> _playAudio() async {
    final audioUrl = _plant['audio_url'];
    if (audioUrl == null || audioUrl.isEmpty) return;
    setState(() => _isPlayingAudio = true);
    try {
      await _audioPlayer.stop();
      final localPath = await _getLocalAudioPath(audioUrl);
      await _audioPlayer.play(DeviceFileSource(localPath));
    } catch (e) {
      setState(() => _isPlayingAudio = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('failedToPlayAudio'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9FBE7),
          body: Stack(
            children: [
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              if (!_isLoading)
                CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTitleAudioRow(),
                              const SizedBox(height: 20),
                              _buildDescription(),
                              const SizedBox(height: 20),
                              _buildPlantInfo(),
                              const SizedBox(height: 20),
                              _buildUsesCard(),
                              const SizedBox(height: 100), // for navbar spacing
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomNavBar(
                  selectedIndex: 1,
                  onTabSelected: (index) {
                    if (index == 0) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else if (index == 1) {
                      // Already here
                    } else if (index == 2) {
                      Navigator.pushReplacementNamed(context, '/settings');
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: const Color(0xFF4CAF50),
      leading: Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 28,
            shadows: [Shadow(blurRadius: 8, color: Colors.black)],
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8),
          child: IconButton(
            icon: const Icon(Icons.language, color: Colors.white, size: 28),
            onPressed: _showLanguageSelector,
            tooltip: 'Change Language',
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (_imageUrls.isNotEmpty)
              PageView.builder(
                controller: _pageController,
                itemCount: _imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: _imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: const Color(0xFF4CAF50),
                          child: const Center(
                            child: Icon(
                              Icons.eco,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color: const Color(0xFF4CAF50),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.eco, size: 100, color: Colors.white),
                                SizedBox(height: 16),
                                Text(
                                  'imageNotAvailable',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  );
                },
              )
            else
              Container(
                color: const Color(0xFF4CAF50),
                child: const Center(
                  child: Icon(Icons.eco, size: 100, color: Colors.white),
                ),
              ),
            // Gradient only at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 90,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),
            ),
            // Page indicator
            if (_imageUrls.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_imageUrls.length, (i) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentImageIndex == i
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAudioRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            _plant['name'] ?? 'unknownPlant'.tr(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
              fontFamily: 'Poppins',
              letterSpacing: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 16),
        if ((_plant['audio_url'] ?? '').isNotEmpty)
          GestureDetector(
            onTap: _isPlayingAudio ? null : _playAudio,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  _isPlayingAudio
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : FaIcon(
                        FontAwesomeIcons.volumeHigh,
                        color: Colors.green[800],
                        size: 30,
                      ),
            ),
          ),
      ],
    );
  }

  Widget _buildDescription() {
    final description = _plant['description'] ?? 'noDescriptionAvailable'.tr();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description, color: Color(0xFF4CAF50)),
                const SizedBox(width: 8),
                Text(
                  'description'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF424242),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'plantInformation'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'scientificName'.tr(),
              _plant['scientific_name'] ?? 'notAvailable'.tr(),
            ),
            _buildInfoRow(
              'plantFamily'.tr(),
              _plant['family'] ?? 'notAvailable'.tr(),
            ),
            _buildInfoRow(
              'plantCategory'.tr(),
              _plant['category'] ?? 'notAvailable'.tr(),
            ),
            if (_plant['genus'] != null)
              _buildInfoRow('genus'.tr(), _plant['genus']),
            if (_plant['species'] != null)
              _buildInfoRow('species'.tr(), _plant['species']),
            if (_plant['toxicity_level'] != null)
              _buildInfoRow('toxicityLevel'.tr(), _plant['toxicity_level']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF2E7D32)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsesCard() {
    final uses = _plant['uses'] ?? '';
    String usesString = '';
    if (uses is String) {
      usesString = uses;
    } else if (uses is List) {
      usesString = uses.join(', ');
    } else {
      usesString = uses.toString();
    }
    final items =
        usesString
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_florist, color: Color(0xFF4CAF50)),
                const SizedBox(width: 8),
                Text(
                  'plantUses'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              Text(
                'noUsesInfoAvailable'.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            for (final use in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF4CAF50),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(use, style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
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
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final double size;
  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              selected
                  ? const Color(0xFF4CAF50).withOpacity(0.12)
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: size,
          color: selected ? const Color(0xFF4CAF50) : Colors.grey.shade500,
        ),
      ),
    );
  }
}
