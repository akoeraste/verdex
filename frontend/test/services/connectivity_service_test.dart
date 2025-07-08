import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:verdex/services/connectivity_service.dart';
import 'dart:async';

import 'connectivity_service_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  group('ConnectivityService Tests', () {
    late ConnectivityService connectivityService;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockConnectivity = MockConnectivity();
      connectivityService = ConnectivityService();
    });

    group('Initialization Tests', () {
      test('should initialize connectivity service', () async {
        // Arrange
        when(
          mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => Stream.value([ConnectivityResult.wifi]));

        // Act
        await connectivityService.initialize();

        // Assert
        expect(connectivityService.isConnected, isNotNull);
      });

      test('should set initial connectivity status', () async {
        // Arrange
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Act
        await connectivityService.initialize();

        // Assert
        expect(connectivityService.isConnected, isTrue);
      });
    });

    group('Connectivity Status Tests', () {
      test('should return true for wifi connection', () async {
        // Arrange
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Act
        await connectivityService.initialize();

        // Assert
        expect(connectivityService.isConnected, isTrue);
      });

      test('should return true for mobile connection', () async {
        // Arrange
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.mobile]);

        // Act
        await connectivityService.initialize();

        // Assert
        expect(connectivityService.isConnected, isTrue);
      });

      test('should return true for ethernet connection', () async {
        // Arrange
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.ethernet]);

        // Act
        await connectivityService.initialize();

        // Assert
        expect(connectivityService.isConnected, isTrue);
      });

      test('should return false for no connection', () async {
        // Arrange
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.none]);

        // Act
        await connectivityService.initialize();

        // Assert
        expect(connectivityService.isConnected, isFalse);
      });

      test('should return false for bluetooth connection', () async {
        // Arrange
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.bluetooth]);

        // Act
        await connectivityService.initialize();

        // Assert
        expect(connectivityService.isConnected, isFalse);
      });
    });

    group('Connectivity Change Tests', () {
      test('should update status when connectivity changes', () async {
        // Arrange
        final connectivityStream = StreamController<List<ConnectivityResult>>();
        when(
          mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Act
        await connectivityService.initialize();
        connectivityStream.add([ConnectivityResult.none]);

        // Wait for the stream to process
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(connectivityService.isConnected, isFalse);
      });

      test('should notify listeners when connectivity changes', () async {
        // Arrange
        final connectivityStream = StreamController<List<ConnectivityResult>>();
        when(
          mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        bool listenerCalled = false;
        connectivityService.addListener(() {
          listenerCalled = true;
        });

        // Act
        await connectivityService.initialize();
        connectivityStream.add([ConnectivityResult.none]);

        // Wait for the stream to process
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(listenerCalled, isTrue);
      });
    });

    group('Error Handling Tests', () {
      test('should handle connectivity check errors', () async {
        // Arrange
        when(
          mockConnectivity.checkConnectivity(),
        ).thenThrow(Exception('Connectivity check failed'));

        // Act & Assert
        expect(
          () => connectivityService.initialize(),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle stream errors gracefully', () async {
        // Arrange
        final connectivityStream = StreamController<List<ConnectivityResult>>();
        when(
          mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Act
        await connectivityService.initialize();
        connectivityStream.addError(Exception('Stream error'));

        // Wait for the stream to process
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - should not throw and should maintain last known state
        expect(connectivityService.isConnected, isTrue);
      });
    });

    group('Disposal Tests', () {
      test('should dispose resources properly', () async {
        // Arrange
        final connectivityStream = StreamController<List<ConnectivityResult>>();
        when(
          mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        await connectivityService.initialize();

        // Act
        connectivityService.dispose();

        // Assert
        expect(connectivityService.isConnected, isFalse);
      });
    });

    group('Manual Status Check Tests', () {
      test('should check connectivity status manually', () async {
        // Arrange
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Act
        final isConnected = await connectivityService.checkConnectivity();

        // Assert
        expect(isConnected, isTrue);
      });

      test('should return false for manual check when no connection', () async {
        // Arrange
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.none]);

        // Act
        final isConnected = await connectivityService.checkConnectivity();

        // Assert
        expect(isConnected, isFalse);
      });
    });
  });
}
