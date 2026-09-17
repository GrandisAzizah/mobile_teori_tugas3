import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/anggota_service.dart';
import '../models/anggota_model.dart';

// Data fallback dipakai kalau fetch ke get_anggota.php gagal/belum aktif, supaya halaman tetap bisa dites duluan. Otomatis kepakai data asli begitu API-nya jalan.
final List<AnggotaModel> _anggotaFallback = [
  AnggotaModel(id: 1, nama: 'Grandis Nur Azizah', nim: '124240045'),
  AnggotaModel(id: 2, nama: 'Chairun Feyza Hersaputri', nim: '124240105'),
  AnggotaModel(id: 3, nama: 'Anindya Zahir Adianputri', nim: '124240113'),
  AnggotaModel(id: 4, nama: 'Rara Ayu Pratiwi', nim: '124240151'),
];

class DaftarAnggotaPage extends StatefulWidget {
  const DaftarAnggotaPage({super.key});

  @override
  State<DaftarAnggotaPage> createState() => _DaftarAnggotaPageState();
}

class _DaftarAnggotaPageState extends State<DaftarAnggotaPage> {
  final _anggotaService = AnggotaService();
  late Future<List<AnggotaModel>> _futureAnggota;

  @override
  void initState() {
    super.initState();
    _futureAnggota = _muatAnggota();
  }

  void _reload() {
    setState(() {
      _futureAnggota = _muatAnggota();
    });
  }

  // Coba ambil dari API dulu; kalau gagal/kosong, pakai data fallback
  Future<List<AnggotaModel>> _muatAnggota() async {
    try {
      final hasil = await _anggotaService.getAllAnggota();
      return hasil.isNotEmpty ? hasil : _anggotaFallback;
    } catch (_) {
      return _anggotaFallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Daftar Staff',
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<AnggotaModel>>(
          future: _futureAnggota,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.white),
              );
            }

            final daftarAnggota = snapshot.data ?? [];
            if (daftarAnggota.isEmpty) {
              return _buildMessage('Belum ada data staff.');
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              itemCount: daftarAnggota.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppTheme.spacingSmall),
              itemBuilder: (context, index) =>
                  _buildMemberCard(daftarAnggota[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.white),
        ),
      ),
    );
  }

  Widget _buildMemberCard(AnggotaModel anggota) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Row(
          children: [
            // Avatar (buletan) pakai warna gradient utama
            CircleAvatar(
              backgroundColor: AppTheme.primaryDark,
              radius: 28,
              child: Text(
                anggota.nama.isNotEmpty ? anggota.nama[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),

            // Isian nama + nim
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(anggota.nama, style: AppTheme.textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    'NIM: ${anggota.nim}',
                    style: AppTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Ikon person
            const Icon(
              Icons.person_outline,
              color: AppTheme.accentGrey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
