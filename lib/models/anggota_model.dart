class AnggotaModel {
  final int id;
  final String nama;
  final String nim;

  AnggotaModel({required this.id, required this.nama, required this.nim});

  factory AnggotaModel.fromJson(Map<String, dynamic> json) {
    return AnggotaModel(
      id: int.parse(json['id'].toString()),
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
    );
  }
}
