import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyUserId = 'user_id';
  static const String _keyNama = 'user_nama';
  static const String _keyEmail = 'user_email';

  // Simpan session setelah login
  static Future<void> simpanSession({
    required String id,
    required String nama,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, id);
    await prefs.setString(_keyNama, nama);
    await prefs.setString(_keyEmail, email);
  }

  // Ambil data user yang sedang login
  static Future<Map<String, String>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyUserId);
    final nama = prefs.getString(_keyNama);
    final email = prefs.getString(_keyEmail);

    if (id == null || nama == null || email == null) return null;

    return {'id': id, 'nama': nama, 'email': email};
  }

  // Cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
