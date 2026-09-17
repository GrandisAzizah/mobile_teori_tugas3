import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../screen/stopwatch.dart';
import '../screen/bantuan.dart';
import '../screen/home_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int myCurrentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const Stopwatch(),
    const BantuanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👇 BOTTOM NAV BIASA, ROUNDED ATAS
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.background, // 👈 Warna nav
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), // 👈 Rounded kiri atas
            topRight: Radius.circular(24), // 👈 Rounded kanan atas
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2), // 👈 Shadow ke atas
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: myCurrentIndex,
            backgroundColor: AppTheme.background,
            selectedItemColor: AppTheme.primaryDark,
            unselectedItemColor: AppTheme.accentGrey,
            selectedFontSize: 12,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            type:
                BottomNavigationBarType.fixed, // 👈 Biar label selalu keliatan
            onTap: (index) {
              setState(() {
                myCurrentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timer),
                label: 'Stopwatch',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Bantuan'),
            ],
          ),
        ),
      ),
      body: pages[myCurrentIndex],
    );
  }
}
