import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:logger/logger.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'services/auth_service.dart';
import 'services/upload_service.dart';
import 'services/payment_service.dart';
import 'services/storage_service.dart';
import 'services/connectivity_service.dart';
import 'providers/auth_provider.dart';
import 'providers/upload_provider.dart';
import 'providers/print_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/order_provider.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';

final Logger logger = Logger();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartSelfPrinterApp());
}

class SmartSelfPrinterApp extends StatelessWidget {
  const SmartSelfPrinterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final storageService = StorageService();
    final authService = AuthService();
    final uploadService = UploadService(apiClient);
    final paymentService = PaymentService(apiClient);
    final connectivityService = ConnectivityService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PrintProvider(uploadService),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(paymentService, storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storageService)..loadSettings(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(storageService),
        ),
        Provider.value(value: connectivityService),
      ],
      child: _AppBuilder(),
    );
  }
}

class _AppBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        return MaterialApp(
          title: 'Smart Self Printer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.generateRoute,
          builder: (context, child) {
            return ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              ],
            );
          },
        );
      },
    );
  }
}
