import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/connectivity_service.dart';
import '../services/plant_service.dart';
import '../services/auth_service.dart';
import '../constants/api_config.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  DebugScreenState createState() => DebugScreenState();
}

class DebugScreenState extends State<DebugScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  final PlantService _plantService = PlantService();
  final AuthService _authService = AuthService();

  String _connectivityStatus = 'Checking...';
  String _apiStatus = 'Checking...';
  String _authStatus = 'Checking...';
  String _plantsCount = 'Checking...';
  String _cacheStatus = 'Checking...';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check connectivity
      final isConnected = _connectivityService.isConnected;
      setState(() {
        _connectivityStatus = isConnected ? '✅ Connected' : '❌ Disconnected';
      });

      // Check API connection
      final apiWorking = await _plantService.testApiConnection();
      setState(() {
        _apiStatus = apiWorking ? '✅ Working' : '❌ Failed';
      });

      // Check authentication
      final token = await _authService.getToken();
      final user = AuthService.currentUser;
      setState(() {
        _authStatus =
            token != null
                ? '✅ Logged in (${user?['name'] ?? 'Unknown'})'
                : '❌ Not logged in';
      });

      // Try to load plants
      try {
        final plants = await _plantService.getAllPlants();
        setState(() {
          _plantsCount = '✅ ${plants.length} plants loaded';
        });

        // Check cache status
        final cacheStatus = await _plantService.getCacheStatus();
        setState(() {
          _cacheStatus =
              '✅ Cache: ${cacheStatus['cacheSize']} plants, ${cacheStatus['timeSinceLastFetch'] ?? 'N/A'} min ago';
        });
      } catch (e) {
        setState(() {
          _plantsCount = '❌ Failed to load plants: $e';
          _cacheStatus = '❌ Cache error: $e';
        });
      }
    } catch (e) {
      debugPrint('Diagnostic error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearCache() async {
    try {
      await _plantService.clearCache();
      setState(() {
        _cacheStatus = '✅ Cache cleared';
      });
    } catch (e) {
      debugPrint('Error clearing cache: $e');
      setState(() {
        _cacheStatus = '❌ Error clearing cache: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('debug_information'.tr()),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'api_configuration'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('base_url'.tr(namedArgs: {'url': ApiConfig.baseUrl})),
            const SizedBox(height: 16),

            Text(
              'system_status'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),

            _buildStatusCard('connectivity'.tr(), _connectivityStatus),
            _buildStatusCard('api_connection'.tr(), _apiStatus),
            _buildStatusCard('authentication'.tr(), _authStatus),
            _buildStatusCard('plants_data'.tr(), _plantsCount),
            _buildStatusCard('cache_status'.tr(), _cacheStatus),

            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _runDiagnostics,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('run_diagnostics'.tr()),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: _clearCache,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
                  foregroundColor: Colors.white,
                ),
                child: Text('clear_plant_cache'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
