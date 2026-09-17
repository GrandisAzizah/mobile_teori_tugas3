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
                'Panduan penggunaan fitur-fitur aplikasi',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // ===== DAFTAR CARA PAKAI =====
              _buildHelpItem(
                icon: Icons.edit,
                title: '1. CRUD Konser',
                description: 'Menu untuk mengelola data konser meliputi tambah data, edit data, dan hapus data.',
              ),
              _buildHelpItem(
                icon: Icons.mosque,
                title: '2. Menu Konversi Tanggal Hijriah & Umur',
                description: 'Konversi tanggal Masehi ke Hijriah dan perhitungan umur. Input tanggal yang diinginkan lalu klik tombol Konversi ke Hijriah untuk mengetahui kalender Hijriahnya atau klik Hitung Detail Umur untuk mengetahui perhitungan umur dari tanggal yang diinput hingga waktu menginput.',
              ),
              _buildHelpItem(
                icon: Icons.calendar_month,
                title: '3. Menu Konversi Kalender Weton & Saka',
                description: 'Pilih tanggal tertentu dari kalender lalu klik Konversi ke Weton Jawa untuk melihat weton Jawa dari tanggal tersebut atau klik Konversi ke Saka Bali untuk melihat Saka Bali dari tanggal tersebut.',
              ),
              _buildHelpItem(
                icon: Icons.lock_clock_rounded,
                title: '4. Stopwatch',
                description: 'Tekan "Start" untuk memulai lalu tombol "Start" akan berubah menjadi tombol "Pause" yang jika ditekan akan menghentikan perhitungan waktu stopwatch disertai dengan tombol kembali berubah menjadi "Start" untuk melanjutkan hitung waktu pada stopwatch. Tekan "Lap" untuk mencatat waktu. Tekan "Reset" untuk mengulang. Data Lap akan hilang ketika tombol "Reset" ditekan',
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
