class KonserModel {
  final int id;
  final int? agensiId;
  final String namaKonser;
  final String namaGrup;
  final String? tanggal; // format: yyyy-MM-dd
  final String venue;
  final int kapasitas;
  final int tiketTerjual;
  final double hargaTiket;
  final String status; // 'akan_datang' | 'selesai' | 'dibatalkan'

  KonserModel({
    required this.id,
    this.agensiId,
    required this.namaKonser,
    required this.namaGrup,
    this.tanggal,
    required this.venue,
    required this.kapasitas,
    required this.tiketTerjual,
    required this.hargaTiket,
    required this.status,
  });

  // Dipakai untuk menu Kalkulasi Konser (Orang B)
  int get sisaKapasitas => kapasitas - tiketTerjual;
  double get estimasiPendapatan => tiketTerjual * hargaTiket;

  factory KonserModel.fromJson(Map<String, dynamic> json) {
    return KonserModel(
      id: int.parse(json['id'].toString()),
      agensiId: json['agensi_id'] != null
          ? int.tryParse(json['agensi_id'].toString())
          : null,
      namaKonser: json['nama_konser'] ?? '',
      namaGrup: json['nama_grup'] ?? '',
      tanggal: json['tanggal'],
      venue: json['venue'] ?? '',
      kapasitas: int.tryParse(json['kapasitas'].toString()) ?? 0,
      tiketTerjual: int.tryParse(json['tiket_terjual'].toString()) ?? 0,
      hargaTiket: double.tryParse(json['harga_tiket'].toString()) ?? 0,
      status: json['status'] ?? 'akan_datang',
    );
  }
}
