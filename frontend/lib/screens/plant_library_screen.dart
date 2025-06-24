import 'package:flutter/material.dart';
import 'package:verdex/services/plant_service.dart';
import 'package:verdex/widgets/library_plant_card.dart';
import 'package:verdex/screens/plant_details_screen.dart';

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
  String _sortOrder = 'name_asc';
  String _categoryFilter = 'all';

  @override
  void initState() {
    super.initState();
    _fetchPlants();
    _searchController.addListener(_filterPlants);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlants() async {
    final plants = await _plantService.getPlants();
    setState(() {
      _allPlants = plants;
      _filteredPlants = plants;
      _isLoading = false;
      _sortAndFilterPlants();
    });
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
              .where((p) => p['category'].toLowerCase() == _categoryFilter)
              .toList();
    }

    // Filter by search text
    final searchText = _searchController.text.toLowerCase();
    if (searchText.isNotEmpty) {
      tempPlants =
          tempPlants
              .where((p) => p['name'].toLowerCase().contains(searchText))
              .toList();
    }

    // Sort
    tempPlants.sort((a, b) {
      switch (_sortOrder) {
        case 'name_asc':
          return a['name'].compareTo(b['name']);
        case 'name_desc':
          return b['name'].compareTo(a['name']);
        case 'date_asc':
          return DateTime.parse(
            a['created_at'],
          ).compareTo(DateTime.parse(b['created_at']));
        case 'date_desc':
        default:
          return DateTime.parse(
            b['created_at'],
          ).compareTo(DateTime.parse(a['created_at']));
      }
    });

    setState(() {
      _filteredPlants = tempPlants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Library'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredPlants.isEmpty
                    ? const Center(child: Text('No plants found.'))
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: _filteredPlants.length,
                      itemBuilder: (context, index) {
                        final plant = _filteredPlants[index];
                        return LibraryPlantCard(
                          name: plant['name'],
                          imageUrl: plant['image_url'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        PlantDetailsScreen(plant: plant),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
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
    return DropdownButton<String>(
      value: _categoryFilter,
      onChanged: (String? newValue) {
        setState(() {
          _categoryFilter = newValue!;
          _sortAndFilterPlants();
        });
      },
      items:
          <String>['all', 'fruit', 'plant'].map<DropdownMenuItem<String>>((
            String value,
          ) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                'Category: ${value[0].toUpperCase()}${value.substring(1)}',
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: _sortOrder,
      onChanged: (String? newValue) {
        setState(() {
          _sortOrder = newValue!;
          _sortAndFilterPlants();
        });
      },
      items:
          <String>[
            'date_desc',
            'date_asc',
            'name_asc',
            'name_desc',
          ].map<DropdownMenuItem<String>>((String value) {
            final text = value
                .split('_')
                .map((e) => e[0].toUpperCase() + e.substring(1))
                .join(' ');
            return DropdownMenuItem<String>(
              value: value,
              child: Text('Sort by: $text'),
            );
          }).toList(),
    );
  }
}
