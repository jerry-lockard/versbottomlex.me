import 'package:flutter/material.dart';

// Import created screens
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/debug/api_test_screen.dart';

// TODO: Import other screens as they are created

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String streamView = '/stream/view';
  static const String createStream = '/stream/create';
  static const String paymentHistory = '/payment/history';
  static const String settings = '/settings';
  static const String apiTest = '/debug/api-test';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Helper function for screens that aren't implemented yet
    Widget placeholderScreen(BuildContext context, String screenName, {String? id}) {
      return Scaffold(
        appBar: AppBar(title: Text(screenName)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$screenName Screen', style: const TextStyle(fontSize: 20)),
              if (id != null) Text('ID: $id', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              const Text('This screen has not been implemented yet'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    switch (settings.name) {
      // Implemented screens
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      
      // Placeholder screens (to be implemented)
      case register:
        return MaterialPageRoute(builder: (context) => placeholderScreen(context, 'Register'));
      case forgotPassword:
        return MaterialPageRoute(builder: (context) => placeholderScreen(context, 'Forgot Password'));
      case profile:
        final String userId = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (context) => placeholderScreen(context, 'Profile', id: userId));
      case streamView:
        final String streamId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (context) => placeholderScreen(context, 'Stream View', id: streamId),
        );
      case createStream:
        return MaterialPageRoute(builder: (context) => placeholderScreen(context, 'Create Stream'));
      case paymentHistory:
        return MaterialPageRoute(builder: (context) => placeholderScreen(context, 'Payment History'));
      case AppRouter.settings:
        return MaterialPageRoute(builder: (context) => placeholderScreen(context, 'Settings'));
      case apiTest:
        return MaterialPageRoute(builder: (context) => const ApiTestScreen());
      
      // Error route - 404 page
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('No route defined for ${settings.name}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed(home),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}