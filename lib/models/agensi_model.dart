class AgensiModel {
  final int id;
  final String namaAgensi;
  final String? keterangan;

  AgensiModel({required this.id, required this.namaAgensi, this.keterangan});

  factory AgensiModel.fromJson(Map<String, dynamic> json) {
    return AgensiModel(
      id: int.parse(json['id'].toString()),
      namaAgensi: json['nama_agensi'] ?? '',
      keterangan: json['keterangan'],
    );
  }
}
