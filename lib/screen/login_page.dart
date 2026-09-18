import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/auth_service.dart';
import '../bottom_navigation/bottom_navigation.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Email dan password wajib diisi");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.login(email, password);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigationPage()),
      );
    } else {
      setState(() => _errorMessage = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      showAppBar: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            const Icon(Icons.stadium, size: 72, color: AppTheme.accentYellow),
            const SizedBox(height: 16),
            Text(
              'EclipseOps',
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.headlineMedium?.copyWith(
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Staff Panel — Kelola Konser Idol',
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 40),

            // Card putih membungkus form biar kontras dengan gradient
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMedium),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: AppTheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacingLarge),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryDark,
                            ),
                          )
                        : const Text('Login'),
                  ),
                  const SizedBox(
                    height: AppTheme.spacingSmall,
                  ), // >>> TAMBAHAN <
                  TextButton(
                    // >>> TAMBAHAN <
                    onPressed: () => Navigator.push(
                      // >>> TAMBAHAN <
                      context, // >>> TAMBAHAN <
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ), // >>> TAMBAHAN <
                    ), // >>> TAMBAHAN <
                    child: const Text(
                      'Belum punya akun? Daftar di sini',
                    ), // >>> TAMBAHAN <
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
