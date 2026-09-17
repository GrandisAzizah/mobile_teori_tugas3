import 'package:flutter/material.dart';

import 'app_theme.dart';

class GradientScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final bool showAppBar;
  final Widget? floatingActionButton;

  const GradientScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.showAppBar = true,
    this.floatingActionButton,
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
      floatingActionButton: floatingActionButton,
    );
  }
}