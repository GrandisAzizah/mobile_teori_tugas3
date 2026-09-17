import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
import '../models/user_model.dart';

class AuthService {
  // ---------------------------------------------------------
  // LOGIN
  // Return: {"success": true/false, "message": "...", "user": UserModel?}
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/login.php"),
        body: {"email": email, "password": password},
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final user = UserModel.fromJson(data['user']);
        await _saveSession(user);
        return {"success": true, "message": data['message'], "user": user};
      } else {
        return {"success": false, "message": data['message']};
      }
    } catch (e) {
      return {"success": false, "message": "Gagal terhubung ke server: $e"};
    }
  }

  // ---------------------------------------------------------
  // REGISTER
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> register(
      String nama, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/register.php"),
        body: {"nama": nama, "email": email, "password": password},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Gagal terhubung ke server: $e"};
    }
  }

  // ---------------------------------------------------------
  // SESSION MANAGEMENT (dipakai juga oleh D untuk tombol Logout)
  // ---------------------------------------------------------
  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('userId', user.id);
    await prefs.setString('userNama', user.nama);
    await prefs.setString('userEmail', user.email);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!loggedIn) return null;

    return UserModel(
      id: prefs.getInt('userId') ?? 0,
      nama: prefs.getString('userNama') ?? '',
      email: prefs.getString('userEmail') ?? '',
    );
  }

  // Dipanggil dari tombol Logout (halaman Bantuan milik D)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
