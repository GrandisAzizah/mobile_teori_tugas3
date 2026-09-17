import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/konser_service.dart';
import '../models/konser_model.dart';
import 'konser_form_page.dart';

class KonserListPage extends StatefulWidget {
  const KonserListPage({super.key});

  @override
  State<KonserListPage> createState() => _KonserListPageState();
}

class _KonserListPageState extends State<KonserListPage> {
  final _konserService = KonserService();

  late Future<List<KonserModel>> _futureKonser;

  @override
  void initState() {
    super.initState();
    _futureKonser = _konserService.getAllKonser();
  }

  void _reload() {
    setState(() {
      _futureKonser = _konserService.getAllKonser();
    });
  }

  Future<void> _hapus(KonserModel konser) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Konser'),
        content: Text('Hapus "${konser.namaKonser}" dari daftar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    final result = await _konserService.hapusKonser(konser.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Konser dihapus')),
    );
    _reload();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'dibatalkan':
        return AppTheme.error;
      default:
        return AppTheme.accentYellow;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'selesai':
        return 'Selesai';
      case 'dibatalkan':
        return 'Dibatalkan';
      default:
        return 'Akan Datang';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'CRUD Konser',
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<KonserModel>>(
          future: _futureKonser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.white),
              );
            }

            if (snapshot.hasError) {
              return _buildMessage(
                'Gagal memuat data konser.\n${snapshot.error}',
              );
            }

            final daftarKonser = snapshot.data ?? [];
            if (daftarKonser.isEmpty) {
              return _buildMessage(
                'Belum ada data konser. Tekan + untuk menambah.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              itemCount: daftarKonser.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppTheme.spacingSmall),
              itemBuilder: (context, index) {
                final konser = daftarKonser[index];
                return _buildKonserCard(konser);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentYellow,
        foregroundColor: AppTheme.primaryDark,
        onPressed: () async {
          final berhasil = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const KonserFormPage()),
          );
          if (berhasil == true) _reload();
        },
        child: const Icon(Icons.add),
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

  Widget _buildKonserCard(KonserModel konser) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    konser.namaKonser,
                    style: AppTheme.textTheme.titleLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(konser.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusLabel(konser.status),
                    style: TextStyle(
                      color: _statusColor(konser.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(konser.namaIdol, style: AppTheme.textTheme.bodyMedium),
            const SizedBox(height: 2),
            Text(
              '${konser.venue} • ${konser.tanggal ?? "-"}',
              style: AppTheme.textTheme.bodySmall,
            ),
            const SizedBox(height: 2),
            Text(
              'Tiket: ${konser.tiketTerjual}/${konser.kapasitas}',
              style: AppTheme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final berhasil = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KonserFormPage(konser: konser),
                      ),
                    );
                    if (berhasil == true) _reload();
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () => _hapus(konser),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppTheme.error,
                  ),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(color: AppTheme.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
