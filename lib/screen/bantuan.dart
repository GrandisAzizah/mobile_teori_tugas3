import 'package:flutter/material.dart';
import 'package:mobile_teori_tugas3/theme/app_theme.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ===== JUDUL =====
              const Text(
                'Cara Penggunaan Aplikasi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Panduan lengkap fitur-fitur aplikasi',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // ===== DAFTAR CARA PAKAI =====
              _buildHelpItem(
                icon: Icons.login,
                title: '1. Login',
                description: 'Masukkan username dan password. Jika salah, akan muncul peringatan.',
              ),
              _buildHelpItem(
                icon: Icons.edit,
                title: '2. (Tunggu menu selesai)',
                description: '(Tunggu menu selesai).',
              ),
              _buildHelpItem(
                icon: Icons.mosque,
                title: '3. Menu Konversi Tanggal Hijriah',
                description:
                    'Konversi tanggal Masehi ke Hijriah dan sebaliknya.',
              ),
              _buildHelpItem(
                icon: Icons.calendar_month,
                title: '4. Menu Konversi Kalender',
                description: 'Hitung umur dari tanggal lahir (tahun, bulan, hari, jam, menit, detik). Juga konversi ke Kalender Jawa dan Saka.',
              ),
              _buildHelpItem(
                icon: Icons.lock_clock_rounded,
                title: '5. Stopwatch',
                description: 'Tekan "Start" untuk memulai. Tekan "Lap" untuk mencatat waktu. Tekan "Pause" untuk berhenti. Tekan "Reset" untuk mengulang.',
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // ===== TOMBOL LOGOUT =====
              ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                  foregroundColor: AppTheme.background,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ===== WIDGET HELPER: ITEM BANTUAN =====
  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryDark,
          child: Icon(icon, color: AppTheme.background, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            description,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  // ===== DIALOG LOGOUT =====
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_page',
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
