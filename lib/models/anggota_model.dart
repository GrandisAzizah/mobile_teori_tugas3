class AnggotaModel {
  final String id;
  final String nama;
  final String nim;

  AnggotaModel({required this.id, required this.nama, required this.nim});

  factory AnggotaModel.fromMap(Map<String, dynamic> map) {
    return AnggotaModel(
      id: map['id']?.toString() ?? '',
      nama: map['nama'] ?? '',
      nim: map['nim'] ?? '',
    );
  }
}
