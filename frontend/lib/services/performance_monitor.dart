import 'dart:async';
import 'package:flutter/foundation.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _timers = {};
  final Map<String, List<int>> _metrics = {};
  bool _isEnabled = true;

  // Enable/disable performance monitoring
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  // Start timing an operation
  void startTimer(String operation) {
    if (!_isEnabled) return;

    _timers[operation] = Stopwatch()..start();
    debugPrint('⏱️ [Performance] Started timing: $operation');
  }

  // Stop timing an operation and log the result
  void stopTimer(String operation) {
    if (!_isEnabled) return;

    final timer = _timers[operation];
    if (timer != null) {
      timer.stop();
      final duration = timer.elapsedMilliseconds;

      // Store metric for analysis
      _metrics.putIfAbsent(operation, () => []).add(duration);

      debugPrint('⏱️ [Performance] $operation took: ${duration}ms');

      // Warn if operation is slow
      if (duration > 1000) {
        debugPrint(
          '⚠️ [Performance] SLOW OPERATION: $operation took ${duration}ms',
        );
      }

      _timers.remove(operation);
    }
  }

  // Time an async operation
  Future<T> timeOperation<T>(
    String operation,
    Future<T> Function() callback,
  ) async {
    if (!_isEnabled) return await callback();

    startTimer(operation);
    try {
      final result = await callback();
      stopTimer(operation);
      return result;
    } catch (e) {
      stopTimer(operation);
      rethrow;
    }
  }

  // Get performance statistics for an operation
  Map<String, dynamic> getOperationStats(String operation) {
    final durations = _metrics[operation];
    if (durations == null || durations.isEmpty) {
      return {};
    }

    durations.sort();
    final avg = durations.reduce((a, b) => a + b) / durations.length;
    final median = durations[durations.length ~/ 2];
    final min = durations.first;
    final max = durations.last;

    return {
      'operation': operation,
      'count': durations.length,
      'average': avg.round(),
      'median': median,
      'min': min,
      'max': max,
      'last': durations.last,
    };
  }

  // Get all performance statistics
  Map<String, Map<String, dynamic>> getAllStats() {
    final stats = <String, Map<String, dynamic>>{};
    for (final operation in _metrics.keys) {
      stats[operation] = getOperationStats(operation);
    }
    return stats;
  }

  // Print performance summary
  void printPerformanceSummary() {
    if (!_isEnabled) return;

    debugPrint('📊 [Performance] Performance Summary:');
    final stats = getAllStats();

    for (final entry in stats.entries) {
      final stat = entry.value;
      debugPrint(
        '  ${stat['operation']}: ${stat['average']}ms avg (${stat['count']} calls)',
      );
    }
  }

  // Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    _timers.clear();
    debugPrint('📊 [Performance] Metrics cleared');
  }

  // Check if any operations are currently being timed
  bool get hasActiveTimers => _timers.isNotEmpty;

  // Get active timers
  Map<String, Stopwatch> get activeTimers => Map.unmodifiable(_timers);

  // Memory usage monitoring
  void logMemoryUsage(String context) {
    if (!_isEnabled) return;

    // This is a simplified memory check - in production you might want to use
    // more sophisticated memory monitoring
    debugPrint('💾 [Performance] Memory check at: $context');
  }

  // Network performance monitoring
  void logNetworkRequest(String endpoint, int statusCode, int duration) {
    if (!_isEnabled) return;

    final status = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    debugPrint(
      '🌐 [Performance] $status $endpoint: ${statusCode} (${duration}ms)',
    );

    if (duration > 5000) {
      debugPrint('⚠️ [Performance] SLOW NETWORK: $endpoint took ${duration}ms');
    }
  }

  // Widget rebuild monitoring
  void logWidgetRebuild(String widgetName) {
    if (!_isEnabled) return;

    debugPrint('🔄 [Performance] Widget rebuilt: $widgetName');
  }

  // Dispose the monitor
  void dispose() {
    clearMetrics();
  }
}

// Convenience extension for timing operations
extension PerformanceExtension on Future {
  Future<T> timeOperation<T>(String operation) async {
    return await PerformanceMonitor().timeOperation(
      operation,
      () => this as Future<T>,
    );
  }
}
