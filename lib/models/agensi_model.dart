class AgensiModel {
  final String id;
  final String namaAgensi;
  final String? keterangan;

  AgensiModel({required this.id, required this.namaAgensi, this.keterangan});

  factory AgensiModel.fromMap(Map<String, dynamic> map) {
    return AgensiModel(
      id: map['id']?.toString() ?? '',
      namaAgensi: map['nama_agensi'] ?? '',
      keterangan: map['keterangan'],
    );
  }
}
