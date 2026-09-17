import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------------------------------------------------------
  // LOGIN
  // Cari user di collection 'users' yang email & password cocok
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final result = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        return {"success": false, "message": "Email atau password salah"};
      }

      final doc = result.docs.first;
      final data = doc.data();

      final user = UserModel(
        id: 0, // Firestore pakai string ID, tapi UserModel pakai int.
        // Untuk sekarang pakai 0, atau ubah model kalau perlu.
        nama: data['nama'] ?? '',
        email: data['email'] ?? '',
      );

      await _saveSession(user);
      return {"success": true, "message": "Login berhasil", "user": user};
    } catch (e) {
      return {"success": false, "message": "Gagal login: $e"};
    }
  }

  // ---------------------------------------------------------
  // REGISTER
  // Simpan user baru ke collection 'users'
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String password,
  ) async {
    try {
      // Cek apakah email sudah terdaftar
      final cek = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (cek.docs.isNotEmpty) {
        return {"success": false, "message": "Email sudah terdaftar"};
      }

      // Simpan user baru
      await _db.collection('users').add({
        'nama': nama,
        'email': email,
        'password': password, // Catatan: nanti sebaiknya di-hash
        'created_at': FieldValue.serverTimestamp(),
      });

      return {"success": true, "message": "Registrasi berhasil, silakan login"};
    } catch (e) {
      return {"success": false, "message": "Gagal register: $e"};
    }
  }

  // ---------------------------------------------------------
  // SESSION MANAGEMENT (SharedPreferences)
  // ---------------------------------------------------------
  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
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
      id: 0,
      nama: prefs.getString('userNama') ?? '',
      email: prefs.getString('userEmail') ?? '',
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
