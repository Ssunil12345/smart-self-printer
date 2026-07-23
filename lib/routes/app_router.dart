import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/upload/upload_screen.dart';
import '../screens/print_options/print_options_screen.dart';
import '../screens/loading/loading_screen.dart';
import '../screens/preview/preview_screen.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/success/success_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/settings/settings_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashScreen(), settings);
      case AppRoutes.login:
        return _buildRoute(const LoginScreen(), settings);
      case AppRoutes.dashboard:
        return _buildRoute(const DashboardScreen(), settings);
      case AppRoutes.upload:
        return _buildRoute(const UploadScreen(), settings);
      case AppRoutes.printOptions:
        return _buildRoute(const PrintOptionsScreen(), settings);
      case AppRoutes.loading:
        return _buildRoute(const LoadingScreen(), settings);
      case AppRoutes.preview:
        return _buildRoute(const PreviewScreen(), settings);
      case AppRoutes.payment:
        return _buildRoute(const PaymentScreen(), settings);
      case AppRoutes.success:
        return _buildRoute(const SuccessScreen(), settings);
      case AppRoutes.history:
        return _buildRoute(const HistoryScreen(), settings);
      case AppRoutes.settings:
        return _buildRoute(const SettingsScreen(), settings);
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.05);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: curve),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
