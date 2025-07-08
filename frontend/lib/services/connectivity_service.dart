import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = true;
  bool _isInitialized = false;

  bool get isConnected => _isConnected;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Get initial connectivity status
    final results = await _connectivity.checkConnectivity();
    _isConnected = !results.contains(ConnectivityResult.none);
    _isInitialized = true;

    print(
      '🌐 [ConnectivityService] App launched - Connection status: ${_isConnected ? "ONLINE" : "OFFLINE"} (${results.map((r) => r.name).join(', ')})',
    );

    // Listen to connectivity changes (reactive monitoring only)
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final wasConnected = _isConnected;
      _isConnected = !results.contains(ConnectivityResult.none);

      print(
        '🌐 [ConnectivityService] Connection changed: ${_isConnected ? "ONLINE" : "OFFLINE"} (${results.map((r) => r.name).join(', ')})',
      );

      if (wasConnected != _isConnected) {
        notifyListeners();
      }
    });

    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    final wasConnected = _isConnected;
    _isConnected = !results.contains(ConnectivityResult.none);

    print(
      '🌐 [ConnectivityService] Manual check - Connection status: ${_isConnected ? "ONLINE" : "OFFLINE"} (${results.map((r) => r.name).join(', ')})',
    );

    if (wasConnected != _isConnected) {
      notifyListeners();
    }

    return _isConnected;
  }

  // Force refresh connectivity status
  Future<void> refreshConnectivity() async {
    print('🌐 [ConnectivityService] Refreshing connectivity status...');
    await checkConnectivity();
    notifyListeners();
  }
}
