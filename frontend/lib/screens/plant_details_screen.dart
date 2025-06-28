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
                if (img is Map && img.containsKey('url')) {
                  return img['url'] as String;
                }
                return img.toString();
              })
              .where(
                (url) =>
                    url != null &&
                    url.isNotEmpty &&
                    Uri.tryParse(url)?.hasAbsolutePath == true,
              )
              .toList();
    } else if (widget.plant['image_url'] != null &&
        (widget.plant['image_url'] as String).isNotEmpty &&
        Uri.tryParse(widget.plant['image_url'])?.hasAbsolutePath == true) {
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
        debugPrint('Fetching plant details for ID: $plantId');
        // Use cached data by default, only fetch from API if not in cache
        final plant = await PlantService().getPlantById(plantId);
        if (mounted && plant != null) {
          debugPrint('Successfully loaded plant: ${plant['scientific_name']}');
          setState(() {
            _plant = plant;
            _isLoading = false;
          });
        } else {
          debugPrint('Plant not found or null for ID: $plantId');
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        debugPrint('Error fetching plant $plantId: $e');
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
      debugPrint('Plant ID is null');
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'failedToUpdateFavorite'.tr(namedArgs: {'error': e.toString()}),
            ),
          ),
        );
      }
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
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('failedToPlayAudio'.tr())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFBFC),
          body: Stack(
            children: [
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF667EEA),
                    ),
                  ),
                ),
              if (!_isLoading)
                CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTitleAudioRow(),
                              const SizedBox(height: 24),
                              _buildDescription(),
                              const SizedBox(height: 24),
                              _buildPlantInfo(),
                              const SizedBox(height: 24),
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
      backgroundColor: const Color(0xFF667EEA),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(16.0),
        child: Container(
          height: 16.0,
          decoration: const BoxDecoration(
            color: Color(0xFF667EEA),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, right: 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Favorite icon
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: _toggleFavorite,
                  tooltip: 'Favorite',
                ),
              ),
              // Language icon
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: _showLanguageSelector,
                  tooltip: 'Change Language',
                ),
              ),
            ],
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
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
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
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.white,
                                ),
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
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
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
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
              child:
                  _isPlayingAudio
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const FaIcon(
                        FontAwesomeIcons.volumeHigh,
                        color: Colors.white,
                        size: 24,
                      ),
            ),
          ),
      ],
    );
  }

  Widget _buildDescription() {
    final description = _plant['description'] ?? 'noDescriptionAvailable'.tr();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'description'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF444444),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.info, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'plantInformation'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w500,
              ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_florist,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'plantUses'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              Text(
                'noUsesInfoAvailable'.tr(),
                style: const TextStyle(color: Color(0xFF666666), fontSize: 16),
              ),
            for (final use in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF667EEA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        use,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF444444),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
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
                if (mounted) {
                  Navigator.pop(context);
                }
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
                              if (mounted) {
                                Navigator.pop(context);
                              }
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
}
