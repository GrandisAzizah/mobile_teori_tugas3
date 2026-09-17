import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../screen/stopwatch.dart';
import '../screen/bantuan.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int myCurrentIndex = 0;

  final List<Widget> pages = [
    const HomePagePlaceholder(),
    const Stopwatch(),
    const BantuanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 500
        ? (screenWidth - 500) / 2
        : 16.0;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 8,
        ),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGrey,
                blurRadius: AppTheme.radius,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              currentIndex: myCurrentIndex,
              backgroundColor: AppTheme.background,
              selectedItemColor: AppTheme.primaryDark,
              unselectedItemColor: AppTheme.accentGrey,
              selectedFontSize: 12,
              showSelectedLabels: true,
              showUnselectedLabels: false,
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.help),
                  label: 'Bantuan',
                ),
              ],
            ),
          ),
        ),
      ),
      body: pages[myCurrentIndex],
    );
  }
}

// ===== PLACEHOLDER BERANDA =====
class HomePagePlaceholder extends StatelessWidget {
  const HomePagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'Beranda\n(Belum Selesai)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
