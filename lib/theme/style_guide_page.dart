import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'gradient_background.dart';

class StyleGuidePage extends StatelessWidget {
  const StyleGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'EclipseOps — Style Guide',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul Halaman (Poppins Bold)',
              style: AppTheme.textTheme.headlineMedium?.copyWith(
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              'Ini contoh teks isi/body pakai font Inter. Dipakai untuk paragraf, deskripsi, dan teks di dalam card.',
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),

            // Card contoh (dipakai untuk list konser, list staff, dll)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contoh Card', style: AppTheme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      'Card dipakai untuk menampilkan 1 item data, misalnya 1 konser atau 1 staff.',
                      style: AppTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),

            // Input field contoh
            const TextField(
              decoration: InputDecoration(
                labelText: 'Contoh Input (misal: Email)',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),

            // Tombol utama (kuning) — dipakai untuk aksi utama: Login, Simpan, Tambah
            ElevatedButton(
              onPressed: () {},
              child: const Text('Tombol Utama (Kuning)'),
            ),
            const SizedBox(height: AppTheme.spacingSmall),

            // Tombol sekunder (abu) — dipakai untuk aksi kedua: Batal, Kembali
            ElevatedButton(
              style: AppTheme.secondaryButtonStyle,
              onPressed: () {},
              child: const Text('Tombol Sekunder (Abu)'),
            ),
            const SizedBox(height: AppTheme.spacingLarge),

            Text(
              'Warna gradient di background halaman ini ('
              '#0F2C59 → #3A6EA5) dipakai di AppBar dan latar utama '
              '(lihat GradientScaffold). Card dan konten pakai warna '
              'solid terang (#F5F7FA / putih) supaya teks tetap kebaca.',
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
