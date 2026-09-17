import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import '../bottom_navigation/bottom_navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final loggedIn = await AuthService().isLoggedIn();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            loggedIn ? const BottomNavigationPage() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const GradientScaffold(
      showAppBar: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stadium, size: 72, color: AppTheme.accentYellow),
            SizedBox(height: 16),
            CircularProgressIndicator(color: AppTheme.white),
          ],
        ),
      ),
    );
  }
}
