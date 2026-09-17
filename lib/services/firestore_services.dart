import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ============ USERS ============

  // Daftar user baru
  Future<void> registerUser({
    required String nama,
    required String email,
    required String password,
  }) async {
    // Cek apakah email sudah terdaftar
    final cek = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (cek.docs.isNotEmpty) {
      throw Exception('Email sudah terdaftar');
    }

    await _db.collection('users').add({
      'nama': nama,
      'email': email,
      'password': password, // nanti kita hash
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Login: cek email + password
  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    final result = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (result.docs.isEmpty) return null;

    final doc = result.docs.first;
    return {'id': doc.id, ...doc.data()};
  }

  // ============ AGENSI ============

  // Ambil semua agensi
  Future<List<Map<String, dynamic>>> getAllAgensi() async {
    final snapshot = await _db.collection('agensi').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  // Tambah agensi
  Future<void> tambahAgensi({
    required String namaAgensi,
    String? keterangan,
  }) async {
    await _db.collection('agensi').add({
      'nama_agensi': namaAgensi,
      'keterangan': keterangan ?? '',
    });
  }

  // ============ KONSER ============

  // Ambil semua konser
  Future<List<Map<String, dynamic>>> getAllKonser() async {
    final snapshot = await _db.collection('konser').orderBy('tanggal').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  // Tambah konser
  Future<void> tambahKonser({
    required String agensiId,
    required String namaKonser,
    required String namaGrup,
    required DateTime tanggal,
    required String venue,
    required int kapasitas,
    required int tiketTerjual,
    required double hargaTiket,
    required String status,
  }) async {
    await _db.collection('konser').add({
      'agensi_id': agensiId,
      'nama_konser': namaKonser,
      'nama_grup': namaGrup,
      'tanggal': Timestamp.fromDate(tanggal),
      'venue': venue,
      'kapasitas': kapasitas,
      'tiket_terjual': tiketTerjual,
      'harga_tiket': hargaTiket,
      'status': status,
    });
  }

  // ============ ANGGOTA ============

  Future<List<Map<String, dynamic>>> getAllAnggota() async {
    final snapshot = await _db.collection('anggota').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<void> tambahAnggota({
    required String nama,
    required String nim,
  }) async {
    await _db.collection('anggota').add({'nama': nama, 'nim': nim});
  }
}
