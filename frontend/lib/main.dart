import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Config
import 'config/app_config.dart';

// Core
import 'core/app_router.dart';

// Data
import 'data/datasources/auth_local_data_source.dart';

// Presentation
import 'presentation/themes/app_theme.dart';

// Utils
import 'utils/logger.dart';

// Providers (to be created)
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/connectivity_provider.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize app configuration
  AppConfig().initialize(env: Environment.dev);

  // Initialize logger
  AppLogger.init();
  AppLogger.i('Starting VersBottomLex app...');

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Create instances of core services
  final authLocalDataSource = AuthLocalDataSource();
  
  // Check stored theme preference
  final savedThemeMode = prefs.getString('themeMode') ?? 'dark';
  final initialThemeMode = savedThemeMode == 'light' 
      ? ThemeMode.light 
      : ThemeMode.dark;

  runApp(MyApp(
    authLocalDataSource: authLocalDataSource,
    initialThemeMode: initialThemeMode,
  ));
}

class MyApp extends StatelessWidget {
  final AuthLocalDataSource authLocalDataSource;
  final ThemeMode initialThemeMode;

  const MyApp({
    super.key,
    required this.authLocalDataSource,
    required this.initialThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authLocalDataSource),
        ),
        
        // Theme provider
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(initialThemeMode),
        ),
        
        // Connectivity provider
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider(Connectivity()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
            navigatorObservers: [
              // Custom route observer for analytics, etc.
              RouteObserver<PageRoute>(),
            ],
            builder: (context, child) {
              // Global error handling, connectivity checker, etc.
              return Consumer<ConnectivityProvider>(
                builder: (context, connectivity, _) {
                  return Column(
                    children: [
                      if (!connectivity.isConnected)
                        Container(
                          color: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          width: double.infinity,
                          child: const Text(
                            'No internet connection',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      Expanded(child: child!),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}