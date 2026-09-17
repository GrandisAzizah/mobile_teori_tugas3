import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final db = FirebaseFirestore.instance;

  print('🚀 Mulai seed data...');

  // ============ 1. AGENSI ============
  print('📦 Mengisi agensi...');
  final agensiRef = db.collection('agensi');

  // Map: nama agensi -> ID dokumen (biar konser bisa refer ke sini)
  final Map<String, String> agensiIds = {};

  final agensiData = [
    {'nama_agensi': 'BigHit Music', 'keterangan': 'Label utama HYBE'},
    {'nama_agensi': 'Pledis Entertainment', 'keterangan': 'Sub-label HYBE'},
    {'nama_agensi': 'ADOR', 'keterangan': 'Sub-label HYBE'},
    {'nama_agensi': 'Source Music', 'keterangan': 'Sub-label HYBE'},
    {'nama_agensi': 'KOZ Entertainment', 'keterangan': 'Sub-label HYBE'},
    {'nama_agensi': 'Belift Lab', 'keterangan': 'Sub-label HYBE'},
  ];

  for (var a in agensiData) {
    final docRef = await agensiRef.add(a);
    agensiIds[a['nama_agensi']!] = docRef.id;
    print('  ✅ ${a['nama_agensi']} -> ${docRef.id}');
  }

  // ============ 2. KONSER ============
  print('🎤 Mengisi konser...');
  final konserRef = db.collection('konser');

  // Mapping agensi_id dari SQL (1-6) ke nama agensi
  final agensiMap = {
    1: 'BigHit Music',
    2: 'Pledis Entertainment',
    3: 'ADOR',
    4: 'Source Music',
    5: 'KOZ Entertainment',
    6: 'Belift Lab',
  };

  final konserData = [
    {
      'agensi_id': 1,
      'nama_konser': 'World Tour Jakarta Leg',
      'nama_grup': 'BTS',
      'tanggal': '2026-11-15',
      'venue': 'Gelora Bung Karno, Jakarta',
      'kapasitas': 50000,
      'tiket_terjual': 42000,
      'harga_tiket': 1500000.0,
      'status': 'akan_datang',
    },
    {
      'agensi_id': 1,
      'nama_konser': 'Fan Concert Seoul',
      'nama_grup': 'BTS',
      'tanggal': '2026-10-02',
      'venue': 'KSPO Dome, Seoul',
      'kapasitas': 15000,
      'tiket_terjual': 15000,
      'harga_tiket': 900000.0,
      'status': 'akan_datang',
    },
    {
      'agensi_id': 1,
      'nama_konser': 'Comeback Showcase',
      'nama_grup': 'TOMORROW X TOGETHER',
      'tanggal': '2026-09-20',
      'venue': 'Blue Square, Seoul',
      'kapasitas': 3000,
      'tiket_terjual': 2750,
      'harga_tiket': 500000.0,
      'status': 'selesai',
    },
    {
      'agensi_id': 1,
      'nama_konser': 'Asia Tour Manila Leg',
      'nama_grup': 'TOMORROW X TOGETHER',
      'tanggal': '2026-12-05',
      'venue': 'Mall of Asia Arena, Manila',
      'kapasitas': 15000,
      'tiket_terjual': 9800,
      'harga_tiket': 1300000.0,
      'status': 'akan_datang',
    },
    {
      'agensi_id': 2,
      'nama_konser': 'Special Stage Tokyo',
      'nama_grup': 'SEVENTEEN',
      'tanggal': '2026-12-01',
      'venue': 'Tokyo Dome, Tokyo',
      'kapasitas': 40000,
      'tiket_terjual': 18000,
      'harga_tiket': 1800000.0,
      'status': 'akan_datang',
    },
    {
      'agensi_id': 2,
      'nama_konser': 'World Tour Bangkok Leg',
      'nama_grup': 'SEVENTEEN',
      'tanggal': '2026-10-18',
      'venue': 'Impact Arena, Bangkok',
      'kapasitas': 25000,
      'tiket_terjual': 25000,
      'harga_tiket': 1400000.0,
      'status': 'selesai',
    },
    {
      'agensi_id': 2,
      'nama_konser': 'Mini Fanmeeting',
      'nama_grup': 'fromis_9',
      'tanggal': '2026-08-10',
      'venue': 'Sabuga, Bandung',
      'kapasitas': 5000,
      'tiket_terjual': 0,
      'harga_tiket': 750000.0,
      'status': 'dibatalkan',
    },
    {
      'agensi_id': 2,
      'nama_konser': 'Debut Anniversary Stage',
      'nama_grup': 'TWS',
      'tanggal': '2026-09-05',
      'venue': 'Inspire Arena, Incheon',
      'kapasitas': 12000,
      'tiket_terjual': 12000,
      'harga_tiket': 1200000.0,
      'status': 'selesai',
    },
    {
      'agensi_id': 3,
      'nama_konser': 'Bunnies Camp Concert',
      'nama_grup': 'NewJeans',
      'tanggal': '2026-11-22',
      'venue': 'KSPO Dome, Seoul',
      'kapasitas': 20000,
      'tiket_terjual': 19500,
      'harga_tiket': 1350000.0,
      'status': 'akan_datang',
    },
    {
      'agensi_id': 3,
      'nama_konser': 'Asia Tour Jakarta Leg',
      'nama_grup': 'NewJeans',
      'tanggal': '2026-12-20',
      'venue': 'Indonesia Arena, Jakarta',
      'kapasitas': 18000,
      'tiket_terjual': 5000,
      'harga_tiket': 1600000.0,
      'status': 'akan_datang',
    },
    {
      'agensi_id': 4,
      'nama_konser': 'World Tour Singapore Leg',
      'nama_grup': 'LE SSERAFIM',
      'tanggal': '2026-10-30',
      'venue': 'Singapore Indoor Stadium',
      'kapasitas': 12000,
      'tiket_terjual': 12000,
      'harga_tiket': 1450000.0,
      'status': 'selesai',
    },
    {
      'agensi_id': 4,
      'nama_konser': 'Fan Concert Seoul',
      'nama_grup': 'LE SSERAFIM',
      'tanggal': '2026-11-08',
      'venue': 'KSPO Dome, Seoul',
      'kapasitas': 15000,
      'tiket_terjual': 13200,
      'harga_tiket': 1100000.0,
      'status': 'akan_datang',
    },
    {
      'agensi_id': 5,
      'nama_konser': 'Solo Concert Seoul',
      'nama_grup': 'ZICO',
      'tanggal': '2026-09-14',
      'venue': 'YES24 Live Hall, Seoul',
      'kapasitas': 4000,
      'tiket_terjual': 3900,
      'harga_tiket': 950000.0,
      'status': 'selesai',
    },
    {
      'agensi_id': 6,
      'nama_konser': 'Global Tour Jakarta Leg',
      'nama_grup': 'ENHYPEN',
      'tanggal': '2026-11-29',
      'venue': 'Indonesia Arena, Jakarta',
      'kapasitas': 20000,
      'tiket_terjual': 20000,
      'harga_tiket': 1700000.0,
      'status': 'akan_datang',
    },
    {
      'agensi_id': 6,
      'nama_konser': 'World Tour Kuala Lumpur Leg',
      'nama_grup': 'ENHYPEN',
      'tanggal': '2026-10-11',
      'venue': 'Axiata Arena, Kuala Lumpur',
      'kapasitas': 15000,
      'tiket_terjual': 14500,
      'harga_tiket': 1350000.0,
      'status': 'selesai',
    },
    {
      'agensi_id': 6,
      'nama_konser': 'Debut Showcase',
      'nama_grup': 'ILLIT',
      'tanggal': '2026-08-25',
      'venue': 'Blue Square, Seoul',
      'kapasitas': 3000,
      'tiket_terjual': 3000,
      'harga_tiket': 550000.0,
      'status': 'selesai',
    },
    {
      'agensi_id': 6,
      'nama_konser': 'First Fan Concert',
      'nama_grup': 'ILLIT',
      'tanggal': '2026-12-12',
      'venue': 'KSPO Dome, Seoul',
      'kapasitas': 10000,
      'tiket_terjual': 4200,
      'harga_tiket': 1000000.0,
      'status': 'akan_datang',
    },
  ];

  for (var k in konserData) {
    final namaAgensi = agensiMap[k['agensi_id']];
    final agensiDocId = agensiIds[namaAgensi];

    await konserRef.add({
      'agensi_id': agensiDocId, // pakai ID dokumen Firestore
      'nama_agensi': namaAgensi, // simpan juga nama biar gampang
      'nama_konser': k['nama_konser'],
      'nama_grup': k['nama_grup'],
      'tanggal': Timestamp.fromDate(DateTime.parse(k['tanggal'] as String)),
      'venue': k['venue'],
      'kapasitas': k['kapasitas'],
      'tiket_terjual': k['tiket_terjual'],
      'harga_tiket': k['harga_tiket'],
      'status': k['status'],
    });
    print('  ✅ ${k['nama_konser']}');
  }

  // ============ 3. ANGGOTA ============
  print('👥 Mengisi anggota...');
  final anggotaRef = db.collection('anggota');
  final anggotaData = [
    {'nama': 'Grandis Nur Azizah', 'nim': '124240045'},
    {'nama': 'Chairun Feyza Hersa Putri', 'nim': '124240105'},
    {'nama': 'Anindya Zahir Adianputri', 'nim': '124240113'},
    {'nama': 'Rara Ayu Pratiwi', 'nim': '124240151'},
  ];

  for (var a in anggotaData) {
    await anggotaRef.add(a);
    print('  ✅ ${a['nama']}');
  }

  print('🎉 SEED DATA SELESAI!');
}
