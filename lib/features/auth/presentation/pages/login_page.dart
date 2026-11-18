// Login page. Why: Contains the user-facing login screen.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final String? redirectPath;
  final String? redirectUrl;

  const LoginPage({super.key, this.redirectPath, this.redirectUrl});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = const AuthService();

  Future<void> _login() async {
    // ==========================================================
    // YOUR ACTUAL LOGIN API
    // ==========================================================

    // Example only.
    //
    // final response = await loginApi(...);
    //
    // final token = response.token;

    const token = 'example_token_123';

    await _authService.saveToken(token);

    if (!mounted) return;

    // ==========================================================
    // LOGIN SUCCESS
    // ==========================================================

    final redirectPath = widget.redirectPath ?? widget.redirectUrl;

    if (redirectPath != null && redirectPath.isNotEmpty) {
      context.go(redirectPath);
    } else {
      context.go(RouteNames.bottomnavigation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(onPressed: _login, child: const Text('Login')),
      ),
    );
  }
}
