import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

enum Environment { dev, staging, prod }

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  // Current environment
  Environment environment = Environment.dev;

  // API URLs based on environment
  late String apiBaseUrl;
  late String socketUrl;
  late String rtmpUrl;

  // Environment variables getter
  String _getEnv(String key, String defaultValue) {
    return Platform.environment[key] ?? defaultValue;
  }

  // Initialize configuration
  void initialize({Environment env = Environment.dev}) {
    environment = env;

    // Get domain from environment variables if available
    final String primaryDomain = _getEnv('PRIMARY_DOMAIN', 'example.com');
    final String apiPort = _getEnv('API_PORT', '3000');
    
    switch (environment) {
      case Environment.dev:
        apiBaseUrl = _getEnv('DEV_API_URL', 'http://localhost:$apiPort/api');
        socketUrl = _getEnv('DEV_SOCKET_URL', 'http://localhost:$apiPort');
        rtmpUrl = _getEnv('DEV_RTMP_URL', 'rtmp://localhost/live');
        break;
      case Environment.staging:
        apiBaseUrl = _getEnv('STAGING_API_URL', 'https://staging-api.$primaryDomain/api');
        socketUrl = _getEnv('STAGING_SOCKET_URL', 'https://staging-api.$primaryDomain');
        rtmpUrl = _getEnv('STAGING_RTMP_URL', 'rtmp://staging-stream.$primaryDomain/live');
        break;
      case Environment.prod:
        apiBaseUrl = _getEnv('PROD_API_URL', 'https://api.$primaryDomain/api');
        socketUrl = _getEnv('PROD_SOCKET_URL', 'https://api.$primaryDomain');
        rtmpUrl = _getEnv('PROD_RTMP_URL', 'rtmp://stream.$primaryDomain/live');
        break;
    }

    if (kDebugMode) {
      print('App initialized with ${environment.name} environment');
      print('API URL: $apiBaseUrl');
      print('Socket URL: $socketUrl');
      print('RTMP URL: $rtmpUrl');
    }
  }

  // App-wide constants
  static const String appName = 'MyApp';  // Replace with your app name
  static const String appVersion = '1.0.0';
  
  // Feature flags
  final bool enableBiometricAuth = true;
  final bool enableMultiCameras = true;
  final bool enableCryptoPayments = true;
}