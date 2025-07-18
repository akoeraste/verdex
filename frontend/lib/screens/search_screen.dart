import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:verdex/services/plant_service.dart';
import 'package:verdex/screens/plant_details_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PlantService _plantService = PlantService();
  String _selectedFilter = 'all';
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _searchHistory = [];

  final List<String> _filterOptions = [
    'all',
    'fruits',
    'vegetables',
    'herbs',
    'flowers',
    'trees',
    'medicinal',
  ];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() {
    // Pending: Load from local storage
    _searchHistory = [
      {'name': 'Tomato', 'type': 'Vegetable'},
      {'name': 'Basil', 'type': 'Herb'},
    ];
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _plantService.searchPlants(query);

      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults =
              results.where((plant) {
                if (_selectedFilter != 'all') {
                  return plant['category']?.toString().toLowerCase() ==
                      _selectedFilter.toLowerCase();
                }
                return true;
              }).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'searchFailed'.tr(namedArgs: {'error': e.toString()}),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBE7),
      body: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF4CAF50), width: 4.0)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'search_plants'.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E7D32),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),

              // Search Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((255 * 0.1).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      if (value.length >= 2) {
                        _performSearch(value);
                      } else {
                        setState(() {
                          _searchResults = [];
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'search_for_plants'.tr(),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF4CAF50),
                      ),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchResults = [];
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Filter Chips
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filterOptions.length,
                  itemBuilder: (context, index) {
                    final filter = _filterOptions[index];
                    final isSelected = _selectedFilter == filter;
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: FilterChip(
                        label: Text(filter.tr()),
                        selected: isSelected,
                        onSelected: (selected) => _onFilterChanged(filter),
                        backgroundColor: Colors.white,
                        selectedColor: const Color(
                          0xFF4CAF50,
                        ).withAlpha((255 * 0.2).toInt()),
                        checkmarkColor: const Color(0xFF4CAF50),
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey[600],
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? const Color(
                                    0xFF4CAF50,
                                  ).withAlpha((255 * 0.1).toInt())
                                  : Colors.grey[300]!,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Results
              Expanded(child: _buildResultsContent()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
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
    );
  }

  Widget _buildResultsContent() {
    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF4CAF50)),
            SizedBox(height: 16),
            Text(
              'searching'.tr(),
              style: TextStyle(color: Color(0xFF2E7D32), fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_searchController.text.isEmpty) {
      return _buildSearchHistory();
    }

    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 64, color: Color(0xFF4CAF50)),
            const SizedBox(height: 16),
            Text(
              'searchForPlantsToIdentify'.tr(),
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Text(
          'recent_searches'.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 12),
        ..._searchHistory.map((item) => _buildHistoryItem(item)),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.history, color: Color(0xFF4CAF50)),
        title: Text(item['name']),
        subtitle: Text(item['type']),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _searchController.text = item['name'];
          _performSearch(item['name']);
        },
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Color(0xFF4CAF50)),
          SizedBox(height: 16),
          Text(
            'no_plants_found'.tr(),
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'tryDifferentKeywords'.tr(),
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final plant = _searchResults[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantDetailsScreen(plant: plant),
              ),
            );
          },
          child: _buildPlantCard(plant),
        );
      },
    );
  }

  Widget _buildPlantCard(Map<String, dynamic> plant) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                color: const Color(0xFFF1F8E9),
              ),
              child:
                  plant['image_url'] != null && plant['image_url'].isNotEmpty
                      ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          plant['image_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.eco,
                                size: 40,
                                color: Color(0xFF4CAF50),
                              ),
                            );
                          },
                        ),
                      )
                      : const Center(
                        child: Icon(
                          Icons.eco,
                          size: 40,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant['name'] ?? 'unknownPlant'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF2E7D32),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant['scientific_name'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF4CAF50,
                      ).withAlpha((255 * 0.1).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      plant['category'] ?? '',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
