import 'package:flutter/material.dart';

import './theme/app_theme.dart';
import './screen/login_page.dart';
import './screen/bantuan.dart';
import './bottom_navigation/bottom_navigation.dart';
import './screen/stopwatch.dart';

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
      initialRoute: '/main',
      routes: {
        '/login_page': (context) => const LoginPage(),
        '/main': (context) => const BottomNavigationPage(),
        '/stopwatch': (context) => const Stopwatch(),
        '/bantuan': (context) => const BantuanPage(),
      },
    );
  }
}
