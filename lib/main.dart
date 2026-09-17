import 'package:flutter/material.dart';
import 'package:mobile_teori_tugas3/screen/home_page.dart';

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
<<<<<<< HEAD
      initialRoute: '/login_page',
=======
      initialRoute: '/', // <<< SEBELUMNYA: '/main'
>>>>>>> bd2b38b244f583a2820f2277f517e19d881da615
      routes: {
        '/': (context) => const SplashPage(), // >>> TAMBAHAN <
        '/login_page': (context) => const LoginPage(),
        '/register_page': (context) => const RegisterPage(), // >>> TAMBAHAN <
        '/main': (context) => const BottomNavigationPage(),
        '/stopwatch': (context) => const Stopwatch(),
        '/bantuan': (context) => const BantuanPage(),
        '/home_page': (context) => const HomePage(),
      },
    );
  }
}
