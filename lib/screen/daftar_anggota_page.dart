import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/anggota_service.dart';
import '../models/anggota_model.dart';

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
    _futureAnggota = _anggotaService.getAllAnggota();
  }

  void _reload() {
    setState(() {
      _futureAnggota = _anggotaService.getAllAnggota();
    });
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

            if (snapshot.hasError) {
              return _buildMessage(
                'Gagal memuat data staff.\n${snapshot.error}',
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
