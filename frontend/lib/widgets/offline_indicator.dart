import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/connectivity_service.dart';
import 'package:easy_localization/easy_localization.dart';

class OfflineIndicator extends StatelessWidget {
  final bool showText;
  final double size;
  final Color? color;

  const OfflineIndicator({
    super.key,
    this.showText = true,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, child) {
        if (connectivityService.isConnected) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color ?? Colors.red.shade600,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, color: Colors.white, size: size),
              if (showText) ...[
                const SizedBox(width: 4),
                Text(
                  'offline_mode_active'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.75,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
