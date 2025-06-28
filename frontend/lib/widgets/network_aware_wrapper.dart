import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/connectivity_service.dart';
import '../services/auth_service.dart';
import 'package:easy_localization/easy_localization.dart';

class NetworkAwareWrapper extends StatefulWidget {
  final Widget child;
  final bool showOfflineBanner;
  final VoidCallback? onConnectionRestored;

  const NetworkAwareWrapper({
    super.key,
    required this.child,
    this.showOfflineBanner = true,
    this.onConnectionRestored,
  });

  @override
  State<NetworkAwareWrapper> createState() => _NetworkAwareWrapperState();
}

class _NetworkAwareWrapperState extends State<NetworkAwareWrapper> {
  final AuthService _authService = AuthService();
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    final connectivityService = ConnectivityService();
    await connectivityService.initialize();

    // Listen to connectivity changes
    connectivityService.addListener(_onConnectivityChanged);
  }

  void _onConnectivityChanged() {
    final connectivityService = ConnectivityService();

    if (connectivityService.isConnected) {
      // Connection restored
      _syncWhenOnline();
      widget.onConnectionRestored?.call();
    }
  }

  Future<void> _syncWhenOnline() async {
    if (_isSyncing) return;

    setState(() => _isSyncing = true);

    try {
      await _authService.syncWhenOnline();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('connection_restored_sync_complete'.tr()),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('sync_failed_try_again'.tr()),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  @override
  void dispose() {
    ConnectivityService().removeListener(_onConnectivityChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, child) {
        final isConnected = connectivityService.isConnected;

        return Stack(
          children: [
            widget.child,
            if (!isConnected && widget.showOfflineBanner)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildOfflineBanner(),
              ),
            if (_isSyncing)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildSyncingBanner(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'offline_mode_active'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Icon(Icons.refresh, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildSyncingBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'syncing_data'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
