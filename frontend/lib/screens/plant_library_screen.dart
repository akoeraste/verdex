import 'package:flutter/material.dart';
import 'package:verdex/services/plant_service.dart';
import 'package:verdex/widgets/library_plant_card.dart';
import 'package:verdex/screens/plant_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    await _fetchPlants();
    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> _forceRefreshPlants() async {
    setState(() {
      _isRefreshing = true;
    });
    try {
      final plants = await _plantService.forceRefreshPlants();
      setState(() {
        _allPlants = plants;
        _filteredPlants = plants;
        _isRefreshing = false;
        _sortAndFilterPlants();
      });
    } catch (e) {
      setState(() {
        _isRefreshing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error force refreshing plants: $e'),
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
          backgroundColor: const Color(0xFFF9FBE7),
          appBar: AppBar(
            title: Text('plant_library'.tr()),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: const Color(0xFF2E7D32),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.language,
                  color: Color(0xFF4CAF50),
                  size: 28,
                ),
                onPressed: _showLanguageSelector,
                tooltip: 'Change Language',
              ),
            ],
          ),
          body: Column(
            children: [
              _buildSearchAndFilter(),
              Expanded(
                child:
                    _isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4CAF50),
                          ),
                        )
                        : _filteredPlants.isEmpty
                        ? _buildEmptyState()
                        : Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ), // reduced for navbar
                          child: RefreshIndicator(
                            onRefresh: _refreshPlants,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
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
                                            (context) => PlantDetailsScreen(
                                              plant: plant,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
              ),
            ],
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
          Icon(Icons.eco_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'no_plants_available'.tr()
                : 'no_plants_found'.tr(),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_searchController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'try_different_search'.tr(),
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Text(
              'tap_refresh_to_load_plants'.tr(),
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isRefreshing ? null : _refreshPlants,
              icon:
                  _isRefreshing
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.refresh),
              label: Text(_isRefreshing ? 'loading'.tr() : 'refresh'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'search_plants'.tr(),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF4CAF50)),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF4CAF50)),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF1F8E9),
            ),
          ),
          const SizedBox(height: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4CAF50).withAlpha((0.3 * 255).toInt()),
        ),
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
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4CAF50).withAlpha((0.3 * 255).toInt()),
        ),
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

  Future<void> _syncWithBackend() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await _plantService.refreshCache();
      await _fetchPlants();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data refreshed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Refresh failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isRefreshing = false;
      });
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
