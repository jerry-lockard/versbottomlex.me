import 'package:flutter/material.dart';

import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/stream/stream_view_screen.dart';
import '../presentation/screens/stream/create_stream_screen.dart';
import '../presentation/screens/payment/payment_history_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/splash_screen.dart';

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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profile:
        final String userId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(userId: userId),
        );
      case streamView:
        final String streamId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => StreamViewScreen(streamId: streamId),
        );
      case createStream:
        return MaterialPageRoute(builder: (_) => const CreateStreamScreen());
      case paymentHistory:
        return MaterialPageRoute(builder: (_) => const PaymentHistoryScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}