import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

// =========================================================
// INI HANYA PLACEHOLDER sementara supaya alur Login -> Home
// bisa langsung dites, walau Home asli (5 menu vertikal +
// Bottom Nav) belum jadi.
//
// Orang B & D: silakan bikin file Home/BottomNav kalian
// sendiri (pakai GradientScaffold + AppTheme biar konsisten),
// lalu di login_page.dart dan main.dart ganti
// "HomePagePlaceholder()" jadi widget Home asli kalian.
// =========================================================

class HomePagePlaceholder extends StatelessWidget {
  const HomePagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Home (Placeholder)',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await AuthService().logout();
            if (!context.mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
        ),
      ],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 48),
                const SizedBox(height: AppTheme.spacingMedium),
                Text(
                  'Login berhasil!',
                  style: AppTheme.textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Text(
                  'Halaman ini akan diganti dengan Home asli\n'
                  '(5 menu) oleh Orang B, dibungkus Bottom Nav\n'
                  'oleh Orang D.',
                  textAlign: TextAlign.center,
                  style: AppTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
