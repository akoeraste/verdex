import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() {
    // Pending: Load from local storage or API
    setState(() {
      _isFavorite = false;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // Pending: Save to local storage or API
  }

  void _playAudio() {
    setState(() {
      _isPlayingAudio = !_isPlayingAudio;
    });
    // Pending: Implement text-to-speech
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.plant['name'],
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                ),
              ),
              background: Image.network(
                widget.plant['image_url'],
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 150),
              ),
            ),
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey<bool>(_isFavorite),
                    color: Colors.red,
                  ),
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: Icon(
                  _isPlayingAudio ? Icons.volume_up : Icons.volume_down,
                ),
                onPressed: _playAudio,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Family: ${widget.plant['family']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.plant['description'],
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    _buildTabs(),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'uses_tab'.tr()),
            Tab(text: 'tags_tab'.tr()),
            Tab(text: 'reviews_tab'.tr()),
          ],
        ),
        SizedBox(
          height: 200, // Adjust height as needed
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsList(widget.plant['uses']),
              _buildTagsList(widget.plant['tags']),
              Center(child: Text('reviews_placeholder'.tr())),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsList(String details) {
    final items = details.split(',').map((e) => e.trim()).toList();
    return ListView.builder(
      itemCount: items.length,
      itemBuilder:
          (context, index) => ListTile(
            leading: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            title: Text(items[index]),
          ),
    );
  }

  Widget _buildTagsList(List<dynamic> tags) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: tags.map((tag) => Chip(label: Text(tag))).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
