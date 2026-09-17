class UserModel {
  final int id;
  final String nama;
  final String email;

  UserModel({required this.id, required this.nama, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id'].toString()),
      nama: json['nama'],
      email: json['email'],
    );
  }
}
