import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';

class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isConnected = true;
  bool _isInitialized = false;
  bool _isReachable = true;

  bool get isConnected => _isConnected;
  bool get isReachable => _isReachable;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Get initial connectivity status
    final result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;

    // Test actual network reachability
    await _testNetworkReachability();

    _isInitialized = true;

    print(
      '🌐 [ConnectivityService] App launched - Connection status: ${_isConnected ? "ONLINE" : "OFFLINE"} ($result)',
    );
    print('🌐 [ConnectivityService] Network reachable: $_isReachable');

    // Listen to connectivity changes (reactive monitoring only)
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      final wasConnected = _isConnected;
      _isConnected = result != ConnectivityResult.none;

      print(
        '🌐 [ConnectivityService] Connection changed: ${_isConnected ? "ONLINE" : "OFFLINE"} ($result)',
      );

      // Test reachability when connection changes
      if (_isConnected) {
        _testNetworkReachability(); // fire and forget
      } else {
        _isReachable = false;
      }

      if (wasConnected != _isConnected) {
        notifyListeners();
      }
    });

    notifyListeners();
  }

  Future<void> _testNetworkReachability() async {
    try {
      // Test with a simple HEAD request to the API
      final response = await http
          .head(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.healthEndpoint}'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));

      _isReachable = response.statusCode < 500; // Consider 4xx as reachable
      print(
        '🌐 [ConnectivityService] Network reachability test: $_isReachable (status: ${response.statusCode})',
      );
    } catch (e) {
      _isReachable = false;
      print('🌐 [ConnectivityService] Network reachability test failed: $e');
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    final wasConnected = _isConnected;
    _isConnected = result != ConnectivityResult.none;

    print(
      '🌐 [ConnectivityService] Manual check - Connection status: ${_isConnected ? "ONLINE" : "OFFLINE"} ($result)',
    );

    // Test reachability if connected
    if (_isConnected) {
      await _testNetworkReachability();
    } else {
      _isReachable = false;
    }

    if (wasConnected != _isConnected) {
      notifyListeners();
    }

    return _isConnected && _isReachable;
  }

  // Force refresh connectivity status
  Future<void> refreshConnectivity() async {
    print('🌐 [ConnectivityService] Refreshing connectivity status...');
    await checkConnectivity();
    notifyListeners();
  }

  // Get detailed connectivity status
  Map<String, dynamic> getConnectivityStatus() {
    return {
      'isConnected': _isConnected,
      'isReachable': _isReachable,
      'isInitialized': _isInitialized,
    };
  }
}
