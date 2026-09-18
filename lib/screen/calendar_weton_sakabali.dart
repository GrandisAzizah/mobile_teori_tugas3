import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';

class CalendarConversionScreen extends StatefulWidget {
  const CalendarConversionScreen({super.key});

  @override
  State<CalendarConversionScreen> createState() =>
      _CalendarConversionScreenState();
}

class _CalendarConversionScreenState extends State<CalendarConversionScreen> {
  DateTime? _selectedDate;
  String _wetonResult = '-';
  String _sakaResult = '-';

  final List<String> _hariInggris = [
    'Monday', 
    'Tuesday', 
    'Wednesday', 
    'Thursday', 
    'Friday', 
    'Saturday', 
    'Sunday'
  ];

  // Kalender Saka Bali menggunakan referensi Pawukon 
  // 1 Januari 2000 = Saniscara Umanis
  final DateTime _refPawukon = DateTime(2000, 1, 1);

  // Siklus Saptawara (7 hari) 
  final List<String> _saptawara = [
    'Redite', 
    'Soma', 
    'Anggara', 
    'Buda', 
    'Wraspati', 
    'Sukra', 
    'Saniscara'
  ];

  // Siklus Pancawara (5 hari) 
  final List<String> _pancawara = [
    'Umanis', 
    'Paing', 
    'Pon', 
    'Wage', 
    'Kliwon'
  ];

  // Fungsi untuk memunculkan DatePicker 
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1700),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _wetonResult = '-';
        _sakaResult = '-';
      });
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

// FITUR 3: 
// Konversi Kalender Weton Jawa 
  void _convertToWeton() {
    if (_selectedDate == null) return _showSnack("Wajib pilih tanggal terlebih dahulu!");

    // Menggunakan referensi: pada 17 Agustus 1945 = Jumat Legi 
    final referensi = DateTime(1945, 8, 17);
    final selisihHari = _selectedDate!.difference(referensi).inDays;

    // Siklus 7 hari 
    // Senin = index 0
    // Selasa = index 1 
    // Rabu = index 2 
    // Kamis = index 3  
    // Jumat = index 4
    // Sabtu = index 5 
    // Minggu = index 6 
    int hariKe = (4 + selisihHari) % 7;
    if (hariKe < 0) hariKe += 7;

    // Siklus 5 pasaran 
    // Legi = index 0
    // Pahing = index 1 
    // Pon = index 2 
    // Wage = index 3 
    // Kliwon = index 4
    int pasaranKe = selisihHari % 5;
    if (pasaranKe < 0) pasaranKe += 5;

    final List<String> namaHari = [
      'Senen', 
      'Seloso', 
      'Rebo', 
      'Kemis', 
      'Jemuah', 
      'Setu', 
      'Minggu'
    ];

    final List<String> namaPasaran = [
      'Legi', 
      'Pahing', 
      'Pon', 
      'Wage', 
      'Kliwon'
    ];

    setState(() {
      _wetonResult = "${namaHari[hariKe]} ${namaPasaran[pasaranKe]}";
    });
  }


// FITUR 4
// Konversi Kalender Saka Bali (Saptawara dan Pancawara)
  void _convertToSakaBali() {
    if (_selectedDate == null) return _showSnack("Wajib pilih tanggal terlebih dahulu!");

    // Menghitung selisih hari dari referensi Pawukon 
    int selisihHari = _selectedDate!.difference(_refPawukon).inDays;

    // Hari Pawukon (siklus 210 hari)
    int pawukonDay = selisihHari % 210;
    if (pawukonDay < 0) pawukonDay += 210;

    int saptawaraIndex = (pawukonDay + 6) % 7;

    int pancawaraIndex = pawukonDay % 5;

    String hasil =
        "${_saptawara[saptawaraIndex]} ${_pancawara[pancawaraIndex]}";

    setState(() {
      _sakaResult = hasil;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Konversi Kalender Weton Jawa & Saka Bali',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // Kartu untuk memilih tanggal 
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: AppTheme.primaryDark),
                title: Text('Pilih Tanggal', style: AppTheme.textTheme.bodySmall),
                subtitle: Text(
                  _selectedDate == null
                      ? 'Belum ada tanggal dipilih'
                      : "${_hariInggris[_selectedDate!.weekday - 1]}, "
                        "${DateFormat('dd MMMM yyyy').format(_selectedDate!)}",
                  style: AppTheme.textTheme.titleLarge,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _pickDate,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),

            // Tombol Button Weton Jawa
            ElevatedButton.icon(
              onPressed: _convertToWeton,
              icon: const Icon(Icons.star),
              label: const Text('Konversi ke Weton Jawa'),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            
            // Tombol Button Saka Bali 
            ElevatedButton.icon(
              style: AppTheme.secondaryButtonStyle,
              onPressed: _convertToSakaBali,
              icon: const Icon(Icons.temple_hindu),
              label: const Text('Konversi ke Saka Bali'),
            ),
            const SizedBox(height: AppTheme.spacingLarge),

            // Tempat untuk menampilkan hasil
            Text(
              'Hasil',
              style: AppTheme.textTheme.titleLarge?.copyWith(color: AppTheme.white),
            ),
            const SizedBox(height: AppTheme.spacingMedium),

            // Card hasil Weton Jawa 
            Card(
              child: ListTile(
                leading: const Icon(Icons.star, color: AppTheme.primaryDark),
                title: Text('Weton Jawa', style: AppTheme.textTheme.bodySmall),
                subtitle: Text(_wetonResult, style: AppTheme.textTheme.titleLarge),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),

            // Card hasil Saka Bali
            Card(
              child: ListTile(
                leading: const Icon(Icons.temple_hindu, color: AppTheme.primaryDark),
                title: Text('Saka Bali',
                    style: AppTheme.textTheme.bodySmall),
                subtitle: Text(_sakaResult, style: AppTheme.textTheme.titleLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}