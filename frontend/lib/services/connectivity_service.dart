import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _periodicCheckTimer;
  bool _isConnected = true;
  bool _isInitialized = false;

  bool get isConnected => _isConnected;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Get initial connectivity status
    final result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    _isInitialized = true;

    print(
      '🌐 [ConnectivityService] App launched - Connection status: ${_isConnected ? "ONLINE" : "OFFLINE"} (${result.name})',
    );

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      final wasConnected = _isConnected;
      _isConnected = result != ConnectivityResult.none;

      print(
        '🌐 [ConnectivityService] Connection changed: ${_isConnected ? "ONLINE" : "OFFLINE"} (${result.name})',
      );

      if (wasConnected != _isConnected) {
        notifyListeners();
      }
    });

    // Start periodic connection checking every 15 seconds
    _startPeriodicCheck();

    notifyListeners();
  }

  void _startPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 15), (
      timer,
    ) async {
      await _performPeriodicCheck();
    });
  }

  Future<void> _performPeriodicCheck() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final newConnectionStatus = result != ConnectivityResult.none;

      if (newConnectionStatus != _isConnected) {
        print(
          '🌐 [ConnectivityService] Periodic check - Connection status changed: ${newConnectionStatus ? "ONLINE" : "OFFLINE"} (${result.name})',
        );
        _isConnected = newConnectionStatus;
        notifyListeners();
      } else {
        print(
          '🌐 [ConnectivityService] Periodic check - Connection status stable: ${_isConnected ? "ONLINE" : "OFFLINE"} (${result.name})',
        );
      }
    } catch (e) {
      print('🌐 [ConnectivityService] Periodic check failed: $e');
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _periodicCheckTimer?.cancel();
    super.dispose();
  }

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    final wasConnected = _isConnected;
    _isConnected = result != ConnectivityResult.none;

    print(
      '🌐 [ConnectivityService] Manual check - Connection status: ${_isConnected ? "ONLINE" : "OFFLINE"} (${result.name})',
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

  // Stop periodic checking (useful for testing or when app goes to background)
  void stopPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    print('🌐 [ConnectivityService] Periodic check stopped');
  }

  // Restart periodic checking
  void restartPeriodicCheck() {
    print('🌐 [ConnectivityService] Restarting periodic check');
    _startPeriodicCheck();
  }
}
