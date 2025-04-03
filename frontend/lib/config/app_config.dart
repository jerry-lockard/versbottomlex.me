import 'package:flutter/foundation.dart';

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

  // Initialize configuration
  void initialize({Environment env = Environment.dev}) {
    environment = env;

    switch (environment) {
      case Environment.dev:
        apiBaseUrl = 'http://localhost:3000/api';
        socketUrl = 'http://localhost:3000';
        rtmpUrl = 'rtmp://localhost/live';
        break;
      case Environment.staging:
        apiBaseUrl = 'https://staging-api.versbottomlex.me/api';
        socketUrl = 'https://staging-api.versbottomlex.me';
        rtmpUrl = 'rtmp://staging-stream.versbottomlex.me/live';
        break;
      case Environment.prod:
        apiBaseUrl = 'https://api.versbottomlex.me/api';
        socketUrl = 'https://api.versbottomlex.me';
        rtmpUrl = 'rtmp://stream.versbottomlex.me/live';
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
  static const String appName = 'VersBottomLex';
  static const String appVersion = '1.0.0';
  
  // Feature flags
  final bool enableBiometricAuth = true;
  final bool enableMultiCameras = true;
  final bool enableCryptoPayments = true;
}