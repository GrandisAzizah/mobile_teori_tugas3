import 'package:flutter/material.dart';
import 'package:hijri_date_time/hijri_date_time.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';

class DateConversionScreen extends StatefulWidget {
  const DateConversionScreen({super.key});

  @override
  State<DateConversionScreen> createState() => _DateConversionScreenState();
}

class _DateConversionScreenState extends State<DateConversionScreen> {
  DateTime? _selectedDate;
  String _hijriResult = '-';
  String _ageResult = '-';

  final List<String> _hijriMonths = [
    'Muharram', 
    'Safar', 
    'Rabiul Awal', 
    'Rabiul Akhir',
    'Jumadil Awal', 
    'Jumadil Akhir', 
    'Rajab', 
    "Sya'ban",
    'Ramadhan', 
    'Syawal', 
    "Dzulqa'dah", 
    'Dzulhijjah',
  ];

  final List<String> _hariInggris = [
    'Monday', 
    'Tuesday', 
    'Wednesday', 
    'Thursday', 
    'Friday', 
    'Saturday', 
    'Sunday'
  ];

  final List<String> _hariIndonesia = [
    'Senin', 
    'Selasa', 
    'Rabu', 
    'Kamis', 
    'Jumat', 
    'Sabtu', 
    'Minggu'
  ];

  // Fungsi untuk memunculkan DatePicker 
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _hijriResult = '-'; // Untuk mereset hasil saat tanggal baru dipilih 
        _ageResult = '-'; // Untuk mereset hasil saat tanggal baru dipilih 
      });
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

// FITUR 1: 
// Konversi tanggal ke hijriah 
  void _convertToHijri() {
    if (_selectedDate == null) return _showSnack("Wajib pilih tanggal terlebih dahulu!");

    // Konversi tanggal masehi ke hijriah menggunakan konfigurasi global 
    final hijriDate = HijriDateTime.fromGregorian(
      _selectedDate!,
      adjustmentConfiguration: GlobalHijriAdjustmentConfiguration(),
    );
    
    // Mengambil nama hari dari variabel class _hariIndonesia   
    final dayName = _hariIndonesia[_selectedDate!.weekday - 1];
    
    // Mengambil nama bulan dari variabel class _hijriMonths 
    final monthName = _hijriMonths[hijriDate.month - 1];

    setState(() {
      _hijriResult = "$dayName, ${hijriDate.day} $monthName ${hijriDate.year} H";
    });
  }


// FITUR 2: 
// Konversi tanggal lahir ke umur, tahun, bulan, hari, jam, menit, dan detik 
  void _calculateAge() {
    if (_selectedDate == null) return _showSnack("Wajib pilih tanggal lahir terlebih dahulu!");

    final now = DateTime.now(); // Waktu real-time pada saat kita klik tombol "Hitung Detail Umur" 
    final birth = _selectedDate!;
    if (birth.isAfter(now)) return _showSnack("Tanggal lahir tidak boleh melebihi hari ini!");

    // Menghitung selisih dasar 
    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;
    int hours = now.hour - birth.hour;
    int minutes = now.minute - birth.minute;
    int seconds = now.second - birth.second;

    // Logika untuk meminjam 
    if (seconds < 0) { 
      seconds += 60; 
      minutes--; 
    }
    if (minutes < 0) { 
      minutes += 60; 
      hours--; 
    }
    if (hours < 0) { 
      hours += 24; 
      days--; 
    }
    if (days < 0) {
      days += DateTime(now.year, now.month, 0).day;
      months--;
    }
    if (months < 0) { 
      months += 12; 
      years--; 
    }

    setState(() {
      _ageResult = "$years Tahun, $months Bulan, $days Hari, "
                  "$hours Jam, $minutes Menit, $seconds Detik";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Konversi Tanggal Hijriah & Tanggal Lahir',
      
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

            // Tombol button konversi tanggal hijriah 
            ElevatedButton.icon(
              onPressed: _convertToHijri,
              icon: const Icon(Icons.mosque),
              label: const Text('Konversi ke Hijriah'),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            
            // Tombol button menghitung detail umur 
            ElevatedButton.icon(
              style: AppTheme.secondaryButtonStyle,
              onPressed: _calculateAge,
              icon: const Icon(Icons.cake),
              label: const Text('Hitung Detail Umur'),
            ),
            const SizedBox(height: AppTheme.spacingLarge), 

            // Tempat untuk menampilkan hasil 
            Text(
              'Hasil',
              style: AppTheme.textTheme.titleLarge?.copyWith(color: AppTheme.white),
            ),
            const SizedBox(height: AppTheme.spacingMedium),

            Padding(
              padding: const EdgeInsets.only(left: 12, top: 6),
              child: Text(
                '*Konversi Hijriah Berbasis Kalender Umm Al-Qura',
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.white.withValues(alpha: 0.85),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium), 

            // Card hasil konversi tanggal hijriah 
            Card(
              child: ListTile(
                leading: const Icon(Icons.mosque, color: AppTheme.primaryDark),
                title: Text('Tanggal Hijriah', style: AppTheme.textTheme.bodySmall),
                subtitle: Text(_hijriResult, style: AppTheme.textTheme.titleLarge),
              ),
            ),

            // Card hasil menghitung detail umur 
            Card(
              child: ListTile(
                leading: const Icon(Icons.cake, color: AppTheme.primaryDark),
                title: Text('Detail Umur', style: AppTheme.textTheme.bodySmall),
                subtitle: Text(_ageResult, style: AppTheme.textTheme.titleLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}