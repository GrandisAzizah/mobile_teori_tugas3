import 'package:flutter/material.dart';
import 'app_theme.dart';

// =========================================================
// GradientScaffold
// Scaffold siap pakai dengan AppBar transparan + background
// gradient biru sesuai standar UI EclipseOps. Dipakai untuk
// halaman Login, Home, dan halaman lain yang perlu tampilan
// gradient di bagian atas.
//
// Contoh pemakaian:
//
// GradientScaffold(
//   title: 'Login',
//   body: Center(child: Text('Isi halaman di sini')),
// )
// =========================================================

class GradientScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final bool showAppBar;

  const GradientScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: showAppBar
          ? AppBar(
              title: title != null ? Text(title!) : null,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: actions,
            )
          : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(child: body),
      ),
    );
  }
}
