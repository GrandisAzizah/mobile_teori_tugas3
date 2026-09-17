import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/konser_service.dart';
import '../models/konser_model.dart';

class AplikasiKonserPage extends StatefulWidget {
  const AplikasiKonserPage({super.key});

  @override
  State<AplikasiKonserPage> createState() => _AplikasiKonserPageState();
}

class _AplikasiKonserPageState extends State<AplikasiKonserPage> {
  final _konserService = KonserService();
  late Future<List<KonserModel>> _futureKonser;

  KonserModel? _terpilih;

  @override
  void initState() {
    super.initState();
    _futureKonser = _konserService.getAllKonser();
  }

  // Format angka jadi Rupiah sederhana, misal 1500000 -> Rp1.500.000
  String _formatRupiah(double value) {
    final intValue = value.round();
    final digits = intValue.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final posFromRight = digits.length - i;
      buffer.write(digits[i]);
      if (posFromRight > 1 && posFromRight % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp$buffer';
  }

  // Ubah H- jadi teks yang gampang dibaca
  String _formatHMinus(int? hMinus) {
    if (hMinus == null) return '-';
    if (hMinus > 0) return 'H-$hMinus';
    if (hMinus == 0) return 'Hari ini';
    return 'Sudah lewat ${-hMinus} hari';
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Kalkulasi Konser',
      body: FutureBuilder<List<KonserModel>>(
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
              'Belum ada data konser. Tambah dulu lewat menu CRUD Konser.',
            );
          }

          // Kalau yang terpilih hilang dari daftar (misal habis dihapus), reset
          if (_terpilih != null &&
              !daftarKonser.any((k) => k.id == _terpilih!.id)) {
            _terpilih = null;
          }
          _terpilih ??= daftarKonser.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Pilih Konser', style: AppTheme.textTheme.titleLarge),
                  const SizedBox(height: AppTheme.spacingMedium),
                  DropdownButtonFormField<int>(
                    value: _terpilih!.id,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.event_outlined),
                    ),
                    items: daftarKonser
                        .map(
                          (k) => DropdownMenuItem(
                            value: k.id,
                            child: Text('${k.namaKonser} — ${k.namaGrup}'),
                          ),
                        )
                        .toList(),
                    onChanged: (id) {
                      setState(() {
                        _terpilih = daftarKonser.firstWhere((k) => k.id == id);
                      });
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                  const Divider(),
                  const SizedBox(height: AppTheme.spacingSmall),
                  Text('Hasil Kalkulasi', style: AppTheme.textTheme.titleLarge),
                  const SizedBox(height: AppTheme.spacingSmall),
                  _buildHasilRow('Venue', _terpilih!.venue),
                  _buildHasilRow('Tanggal', _terpilih!.tanggal ?? '-'),
                  _buildHasilRow(
                    'Tiket Terjual',
                    '${_terpilih!.tiketTerjual}/${_terpilih!.kapasitas}',
                  ),
                  _buildHasilRow(
                    'Sisa Kapasitas',
                    '${_terpilih!.sisaKapasitas} tiket',
                  ),
                  _buildHasilRow(
                    'Estimasi Pendapatan',
                    _formatRupiah(_terpilih!.estimasiPendapatan),
                  ),
                  _buildHasilRow('Countdown', _formatHMinus(_terpilih!.hMinus)),
                ],
              ),
            ),
          );
        },
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

  Widget _buildHasilRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.textTheme.bodyMedium),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
