import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_update_service.dart';
import '../../../../core/services/auth_service.dart';

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({super.key});

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen> {
  late final ConnectivityService _connectivityService;
  late final AppUpdateService _appUpdateService;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();

    _connectivityService = ConnectivityService();
    _appUpdateService = const AppUpdateService();
    _authService = const AuthService();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // ----------------------------------------------------------
      // SPLASH SCREEN DELAY
      // ----------------------------------------------------------

      await Future<void>.delayed(
        const Duration(milliseconds: 800),
      );

      if (!mounted) return;

      // ----------------------------------------------------------
      // 1. INTERNET CHECK
      // ----------------------------------------------------------

      final hasInternet =
          await _connectivityService.hasInternetConnection();

      if (!mounted) return;

      if (!hasInternet) {
        context.go(RouteNames.noInternet);
        return;
      }

      // ----------------------------------------------------------
      // 2. APP UPDATE CHECK
      // ----------------------------------------------------------

      final updateAvailable =
          await _appUpdateService.isUpdateAvailable();

      if (!mounted) return;

      debugPrint(
        'Update available: $updateAvailable',
      );

      // ----------------------------------------------------------
      // 3. TOKEN CHECK
      // ----------------------------------------------------------

      final hasToken = await _authService.hasToken();

      if (!mounted) return;

      debugPrint(
        'Has authentication token: $hasToken',
      );

      // ----------------------------------------------------------
      // 4. NAVIGATE TO BOTTOM NAVIGATION PAGE
      // ----------------------------------------------------------

      context.go(RouteNames.bottomnavigation);
    } catch (e) {
      debugPrint("Splash Screen Error: $e");

      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircleAvatar(
          backgroundImage: AssetImage(
            "lib/assets/logo-icon.png",
          ),
          radius: 75,
        ),
      ),
    );
  }
}
