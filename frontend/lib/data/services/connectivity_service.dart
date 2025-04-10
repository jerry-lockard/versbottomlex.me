import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../utils/logger.dart';

/// Service to handle connectivity status changes and provide utility methods for checking connectivity
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  
  bool _isConnected = true;
  
  // Getters
  Stream<bool> get connectionStream => _connectionStatusController.stream;
  bool get isConnected => _isConnected;
  
  ConnectivityService._internal() {
    _initConnectivity();
    _setupConnectivityListener();
  }
  
  /// Initialize connectivity status
  Future<void> _initConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      // Handle the first result in the list, or ConnectivityResult.none if empty
      ConnectivityResult result = connectivityResults.isNotEmpty ? connectivityResults.first : ConnectivityResult.none;
      _updateConnectionStatus(result);
    } catch (e) {
      AppLogger.e('Failed to get connectivity: $e');
      _isConnected = false;
      _connectionStatusController.add(_isConnected);
    }
  }

  /// Set up listener for connectivity changes
  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((results) {
      // Handle the first result in the list, or ConnectivityResult.none if empty
      ConnectivityResult result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(result);
    });
  }

  /// Update connection status based on connectivity result
  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = _isConnected;
    _isConnected = result != ConnectivityResult.none;
    
    if (wasConnected != _isConnected) {
      AppLogger.i('Connectivity changed: ${_isConnected ? 'Connected' : 'Disconnected'}');
      _connectionStatusController.add(_isConnected);
    }
  }

  /// Check if device is currently connected to the internet
  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      AppLogger.e('Error checking connectivity: $e');
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _connectionStatusController.close();
  }
}