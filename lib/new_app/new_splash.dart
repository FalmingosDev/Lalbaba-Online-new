// Application splash screen.
// Why: Handle the application startup sequence before entering the main app.

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
      // Small delay to keep the splash screen visible.
      await Future<void>.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      // ----------------------------------------------------------
      // 1. INTERNET CHECK
      // ----------------------------------------------------------

      final hasInternet = await _connectivityService.hasInternetConnection();

      if (!hasInternet) {
        if (!mounted) return;

        context.go(RouteNames.noInternet);
        return;
      }

      // ----------------------------------------------------------
      // 2. APP UPDATE CHECK
      // ----------------------------------------------------------

      final updateAvailable = await _appUpdateService.isUpdateAvailable();

      // if (updateAvailable) {   
      //   if (!mounted) return;

      //   context.go(RouteNames.update);
      //   return;
      // }

      // ----------------------------------------------------------
      // 3. TOKEN CHECK
      // ----------------------------------------------------------

      final hasToken = await _authService.hasToken();

      if (!mounted) return;

      // if (hasToken) {
      //   context.go(RouteNames.bottomnavigation);
      // } else {
      //   context.go(RouteNames.splash);
      // }
      context.go(RouteNames.bottomnavigation);
    } catch (_) {
      if (!mounted) return;

      // If startup check fails unexpectedly,
      // send the user to login rather than leaving them
      // permanently stuck on the splash screen.
      // context.go(RouteNames.splash);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircleAvatar(
          backgroundImage: AssetImage("lib/assets/logo-icon.png"),
          radius: 75,
        ),
      ),
    );
  }
}
