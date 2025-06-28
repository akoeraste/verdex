import 'package:flutter/material.dart';
import 'package:verdex/services/plant_service.dart';
import 'package:verdex/widgets/library_plant_card.dart';
import 'package:verdex/screens/plant_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/bottom_nav_bar.dart';
import 'main_screen.dart';
import 'package:provider/provider.dart';
import 'package:verdex/services/language_service.dart';

class PlantLibraryScreen extends StatefulWidget {
  const PlantLibraryScreen({super.key});

  @override
  State<PlantLibraryScreen> createState() => _PlantLibraryScreenState();
}

class _PlantLibraryScreenState extends State<PlantLibraryScreen> {
  final PlantService _plantService = PlantService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allPlants = [];
  List<Map<String, dynamic>> _filteredPlants = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _sortOrder = 'name_asc';
  String _categoryFilter = 'all';
  String? _lastLanguageCode;

  @override
  void initState() {
    super.initState();
    _fetchPlants();
    _searchController.addListener(_filterPlants);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageService = Provider.of<LanguageService>(context);
    final currentLang = languageService.effectiveLanguageCode;
    if (_lastLanguageCode != currentLang) {
      _lastLanguageCode = currentLang;
      _fetchPlants();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlants() async {
    try {
      final plants = await _plantService.getAllPlants();

      setState(() {
        _allPlants = plants;
        _filteredPlants = plants;
        _isLoading = false;
        _sortAndFilterPlants();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'errorLoadingPlants'.tr(namedArgs: {'error': e.toString()}),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshPlants() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      // Force refresh from API
      final plants = await _plantService.forceRefreshPlants();

      setState(() {
        _allPlants = plants;
        _filteredPlants = plants;
        _isRefreshing = false;
        _sortAndFilterPlants();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Plants refreshed successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isRefreshing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterPlants() {
    _sortAndFilterPlants();
  }

  void _sortAndFilterPlants() {
    List<Map<String, dynamic>> tempPlants = List.from(_allPlants);

    // Filter by category
    if (_categoryFilter != 'all') {
      tempPlants =
          tempPlants
              .where(
                (p) =>
                    (p['category'] ?? '').toString().toLowerCase() ==
                    _categoryFilter,
              )
              .toList();
    }

    // Filter by search text
    final searchText = _searchController.text.toLowerCase();
    if (searchText.isNotEmpty) {
      tempPlants =
          tempPlants
              .where(
                (p) =>
                    (p['name'] ?? '').toString().toLowerCase().contains(
                      searchText,
                    ) ||
                    (p['scientific_name'] ?? '')
                        .toString()
                        .toLowerCase()
                        .contains(searchText) ||
                    (p['description'] ?? '').toString().toLowerCase().contains(
                      searchText,
                    ) ||
                    (p['family'] ?? '').toString().toLowerCase().contains(
                      searchText,
                    ),
              )
              .toList();
    }

    // Sort
    tempPlants.sort((a, b) {
      switch (_sortOrder) {
        case 'name_asc':
          return (a['name'] ?? '').toString().compareTo(
            (b['name'] ?? '').toString(),
          );
        case 'name_desc':
          return (b['name'] ?? '').toString().compareTo(
            (a['name'] ?? '').toString(),
          );
        case 'date_asc':
          try {
            return DateTime.parse(
              a['created_at'] ?? '',
            ).compareTo(DateTime.parse(b['created_at'] ?? ''));
          } catch (e) {
            return 0;
          }
        case 'date_desc':
        default:
          try {
            return DateTime.parse(
              b['created_at'] ?? '',
            ).compareTo(DateTime.parse(a['created_at'] ?? ''));
          } catch (e) {
            return 0;
          }
      }
    });

    setState(() {
      _filteredPlants = tempPlants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFBFC),
          body: SafeArea(
            child: Column(
              children: [
                // Header - Fixed at top
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      // Back button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.of(context).pop(),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'plant_library'.tr(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Refresh button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _isRefreshing ? null : _refreshPlants,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child:
                                  _isRefreshing
                                      ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _showLanguageSelector,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.language,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content area
                Expanded(
                  child:
                      _isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF667EEA),
                              ),
                            ),
                          )
                          : _filteredPlants.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                            onRefresh: _refreshPlants,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                bottom: 100,
                              ), // for navbar
                              child: Column(
                                children: [
                                  // Search and Filter Section - Now scrolls with content
                                  _buildSearchAndFilter(),

                                  // Plants Grid
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                            childAspectRatio: 0.75,
                                          ),
                                      itemCount: _filteredPlants.length,
                                      itemBuilder: (context, index) {
                                        final plant = _filteredPlants[index];
                                        return LibraryPlantCard(
                                          plant: plant,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        PlantDetailsScreen(
                                                          plant: plant,
                                                        ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            selectedIndex: 1,
            onTabSelected: (index) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => MainScreen(initialIndex: index),
                ),
                (route) => false,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.eco_outlined,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchController.text.isEmpty
                ? 'no_plants_available'.tr()
                : 'no_plants_found'.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if (_searchController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'try_different_search'.tr(),
              style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Text(
              'tap_refresh_to_load_plants'.tr(),
              style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isRefreshing ? null : _refreshPlants,
                icon:
                    _isRefreshing
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.refresh),
                label: Text(_isRefreshing ? 'loading'.tr() : 'refresh'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'search_plants'.tr(),
              hintStyle: const TextStyle(
                color: Color(0xFF999999),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF667EEA)),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF667EEA)),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
            ),
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildFilterDropdown(), _buildSortDropdown()],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF667EEA).withOpacity(0.2)),
      ),
      child: DropdownButton<String>(
        value: _categoryFilter,
        underline: Container(),
        onChanged: (String? newValue) {
          setState(() {
            _categoryFilter = newValue!;
            _sortAndFilterPlants();
          });
        },
        items:
            <String>[
              'all',
              'fruit',
              'vegetable',
              'herb',
              'tree',
              'flower',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value == 'all'
                      ? 'all_categories'.tr()
                      : value[0].toUpperCase() + value.substring(1),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF667EEA).withOpacity(0.2)),
      ),
      child: DropdownButton<String>(
        value: _sortOrder,
        underline: Container(),
        onChanged: (String? newValue) {
          setState(() {
            _sortOrder = newValue!;
            _sortAndFilterPlants();
          });
        },
        items: [
          DropdownMenuItem(value: 'name_asc', child: Text('name_a_z'.tr())),
          DropdownMenuItem(value: 'name_desc', child: Text('name_z_a'.tr())),
          DropdownMenuItem(
            value: 'date_desc',
            child: Text('newest_first'.tr()),
          ),
          DropdownMenuItem(value: 'date_asc', child: Text('oldest_first'.tr())),
        ],
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
}
