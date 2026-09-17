import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import '../models/anggota_model.dart';

class AnggotaService {
  Future<List<AnggotaModel>> getAllAnggota() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/get_anggota.php"),
    );
    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return (data['data'] as List)
          .map((item) => AnggotaModel.fromJson(item))
          .toList();
    }
    return [];
  }
}
