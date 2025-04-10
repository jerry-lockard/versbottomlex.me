import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../utils/logger.dart';

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity;
  bool _isConnected = true;
  StreamSubscription? _connectivitySubscription;

  bool get isConnected => _isConnected;

  ConnectivityProvider(this._connectivity) {
    _initConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _initConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      // Handle the list of connectivity results
      if (connectivityResults.isNotEmpty) {
        // Check if any connection is available (not 'none')
        final hasConnection = connectivityResults.any(
          (result) => result != ConnectivityResult.none,
        );
        _updateConnectionStatus(
          hasConnection ? connectivityResults.first : ConnectivityResult.none,
        );
      } else {
        _updateConnectionStatus(ConnectivityResult.none);
      }
    } catch (e) {
      AppLogger.e('Failed to get connectivity: $e');
      _isConnected = false;
      notifyListeners();
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (connectivityResults) {
        if (connectivityResults.isNotEmpty) {
          // Check if any connection is available (not 'none')
          final hasConnection = connectivityResults.any(
            (result) => result != ConnectivityResult.none,
          );
          _updateConnectionStatus(
            hasConnection ? connectivityResults.first : ConnectivityResult.none,
          );
        } else {
          _updateConnectionStatus(ConnectivityResult.none);
        }
      },
    );
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = _isConnected;
    _isConnected = result != ConnectivityResult.none;

    if (wasConnected != _isConnected) {
      AppLogger.i(
        'Connectivity changed: ${_isConnected ? 'Connected' : 'Disconnected'}',
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
