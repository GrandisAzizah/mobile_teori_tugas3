import 'package:cloud_firestore/cloud_firestore.dart';

class KonserModel {
  final String id;
  final String? agensiId;
  final String? namaAgensi;
  final String namaKonser;
  final String namaGrup;
  final DateTime? tanggal;
  final String venue;
  final int kapasitas;
  final int tiketTerjual;
  final double hargaTiket;
  final String status; // 'akan_datang' | 'selesai' | 'dibatalkan'

  KonserModel({
    required this.id,
    this.agensiId,
    this.namaAgensi,
    required this.namaKonser,
    required this.namaGrup,
    this.tanggal,
    required this.venue,
    required this.kapasitas,
    required this.tiketTerjual,
    required this.hargaTiket,
    required this.status,
  });

  // Dipakai untuk menu Kalkulasi Konser
  int get sisaKapasitas => kapasitas - tiketTerjual;
  double get estimasiPendapatan => tiketTerjual * hargaTiket;

  // Hitung H- menuju tanggal konser. Null kalau tanggal kosong.
  // Positif = masih berapa hari lagi, negatif = sudah lewat.
  int? get hMinus {
    if (tanggal == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tglKonser = DateTime(tanggal!.year, tanggal!.month, tanggal!.day);
    return tglKonser.difference(today).inDays;
  }

  // Tampilan tanggal jadi yyyy-MM-dd
  String get tanggalFormatted {
    if (tanggal == null) return '-';
    return '${tanggal!.year.toString().padLeft(4, '0')}-'
        '${tanggal!.month.toString().padLeft(2, '0')}-'
        '${tanggal!.day.toString().padLeft(2, '0')}';
  }

  // map berasal dari FirestoreService: {'id': doc.id, ...doc.data()}
  factory KonserModel.fromMap(Map<String, dynamic> map) {
    return KonserModel(
      id: map['id']?.toString() ?? '',
      agensiId: map['agensi_id']?.toString(),
      namaAgensi: map['nama_agensi'],
      namaKonser: map['nama_konser'] ?? '',
      namaGrup: map['nama_grup'] ?? '',
      tanggal: map['tanggal'] is Timestamp
          ? (map['tanggal'] as Timestamp).toDate()
          : null,
      venue: map['venue'] ?? '',
      kapasitas: (map['kapasitas'] as num?)?.toInt() ?? 0,
      tiketTerjual: (map['tiket_terjual'] as num?)?.toInt() ?? 0,
      hargaTiket: (map['harga_tiket'] as num?)?.toDouble() ?? 0,
      status: map['status'] ?? 'akan_datang',
    );
  }
}
