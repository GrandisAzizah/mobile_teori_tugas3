import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import '../models/konser_model.dart';

class KonserService {
  Future<List<KonserModel>> getAllKonser() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/get_konser.php"),
    );
    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return (data['data'] as List)
          .map((item) => KonserModel.fromJson(item))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> tambahKonser({
    required String namaKonser,
    required String namaIdol,
    required String tanggal, // format: yyyy-MM-dd
    required String venue,
    required int kapasitas,
    int tiketTerjual = 0,
    required double hargaTiket,
    String status = 'akan_datang',
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/tambah_konser.php"),
      body: {
        "nama_konser": namaKonser,
        "nama_idol": namaIdol,
        "tanggal": tanggal,
        "venue": venue,
        "kapasitas": kapasitas.toString(),
        "tiket_terjual": tiketTerjual.toString(),
        "harga_tiket": hargaTiket.toString(),
        "status": status,
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> editKonser({
    required int id,
    required String namaKonser,
    required String namaIdol,
    required String tanggal,
    required String venue,
    required int kapasitas,
    required int tiketTerjual,
    required double hargaTiket,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/edit_konser.php"),
      body: {
        "id": id.toString(),
        "nama_konser": namaKonser,
        "nama_idol": namaIdol,
        "tanggal": tanggal,
        "venue": venue,
        "kapasitas": kapasitas.toString(),
        "tiket_terjual": tiketTerjual.toString(),
        "harga_tiket": hargaTiket.toString(),
        "status": status,
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> hapusKonser(int id) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/hapus_konser.php"),
      body: {"id": id.toString()},
    );
    return jsonDecode(response.body);
  }
}
