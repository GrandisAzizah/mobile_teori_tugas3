import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'daftar_anggota_page.dart';
import 'aplikasi_konser_page.dart';
import 'konser_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'EclipseOps',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kelola Konser Idol',
                textAlign: TextAlign.center,
                style: AppTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.white,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),

              // 5 menu utama, disusun vertikal pakai Column
              _MenuTile(
                icon: Icons.groups_outlined,
                label: 'Daftar Staff',
                subtitle: 'Data kelompok',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DaftarAnggotaPage()),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              _MenuTile(
                icon: Icons.calculate_outlined,
                label: 'Kalkulasi Konser',
                subtitle: 'Hitung pendapatan & okupansi tiket',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AplikasiKonserPage()),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              _MenuTile(
                icon: Icons.event_note_outlined,
                label: 'CRUD Konser',
                subtitle: 'Kelola data konser',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KonserListPage()),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              _MenuTile(
                icon: Icons.calendar_month_outlined,
                label: 'Konversi Tanggal',
                subtitle: 'Menunggu punya Orang C',
                onTap: () => _showPlaceholder(context, 'Konversi Tanggal'),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              _MenuTile(
                icon: Icons.brightness_5_outlined,
                label: 'Kalender Weton & Saka Bali',
                subtitle: 'Menunggu punya Orang C/D',
                onTap: () =>
                    _showPlaceholder(context, 'Kalender Weton & Saka Bali'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String namaMenu) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$namaMenu belum tersedia'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Satu tile menu di Halaman Utama
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMedium,
            vertical: AppTheme.spacingMedium,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryLight,
                radius: 22,
                child: Icon(icon, color: AppTheme.white),
              ),
              const SizedBox(width: AppTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTheme.textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTheme.textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.accentGrey),
            ],
          ),
        ),
      ),
    );
  }
}