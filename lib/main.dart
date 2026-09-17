import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_teori_tugas3/screen/home_page.dart';

import './firebase_options.dart';
import './theme/app_theme.dart';
import './screen/login_page.dart';
import './screen/bantuan.dart';
import './bottom_navigation/bottom_navigation.dart';
import './screen/stopwatch.dart';
import './screen/splash_page.dart';
import './screen/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      initialRoute: '/login_page',
      routes: {
        '/': (context) => const SplashPage(),
        '/login_page': (context) => const LoginPage(),
        '/register_page': (context) => const RegisterPage(),
        '/main': (context) => const BottomNavigationPage(),
        '/stopwatch': (context) => const Stopwatch(),
        '/bantuan': (context) => const BantuanPage(),
        '/home_page': (context) => const HomePage(),
      },
    );
  }
}
