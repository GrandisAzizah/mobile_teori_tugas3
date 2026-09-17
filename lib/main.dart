import 'package:flutter/material.dart';

import './theme/app_theme.dart';
import './screen/login_page.dart';
import './screen/bantuan.dart';
import './bottom_navigation/bottom_navigation.dart';
import './screen/stopwatch.dart';
import './screen/splash_page.dart'; // >>> TAMBAHAN <
import './screen/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EclipseOps',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      // ini dibuat kayak gini supaya bottom nav bisa dipanggil
      initialRoute: '/', // <<< SEBELUMNYA: '/main'
      routes: {
        '/': (context) => const SplashPage(), // >>> TAMBAHAN <
        '/login_page': (context) => const LoginPage(),
        '/register_page': (context) => const RegisterPage(), // >>> TAMBAHAN <
        '/main': (context) => const BottomNavigationPage(),
        '/stopwatch': (context) => const Stopwatch(),
        '/bantuan': (context) => const BantuanPage(),
      },
    );
  }
}
