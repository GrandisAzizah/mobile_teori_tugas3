import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =========================================================
// AppTheme — EclipseOps
// Standar UI dipakai di semua halaman: gradient biru sebagai
// warna utama, tombol kuning (aksi utama) atau abu (aksi
// sekunder/batal), font Poppins untuk judul & Inter untuk teks
// isi. Import file ini di halaman manapun yang butuh warna
// atau gaya sesuai standar.
// =========================================================

class AppTheme {
  // ===== Warna Gradient (dipakai untuk AppBar & background utama) =====
  static const Color primaryDark = Color(0xFF0F2C59);
  static const Color primaryLight = Color(0xFF3A6EA5);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== Warna Solid =====
  static const Color background = Color(0xFFF5F7FA); // background konten/card
  static const Color white = Colors.white;
  static const Color black = Colors.black87;
  static const Color error = Color(0xFFB00020);

  // Tombol
  static const Color accentYellow = Color(
    0xFFFFC107,
  ); // aksi utama (Simpan, Login, Tambah)
  static const Color accentGrey = Color(
    0xFF9E9E9E,
  ); // aksi sekunder (Batal, Kembali)

  // ===== Jarak =====
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;

  // ===== Radius =====
  static const double radius = 12.0;

  // ===== Text Style (Poppins = heading, Inter = body) =====
  static TextTheme get textTheme => TextTheme(
    headlineMedium: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: black,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: black,
    ),
    bodyMedium: GoogleFonts.inter(fontSize: 16, color: black),
    bodySmall: GoogleFonts.inter(
      fontSize: 13,
      color: black.withValues(alpha: 0.7),
    ),
  );

  // ===== Style tombol primer (kuning) — dipakai lewat ElevatedButtonTheme =====
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: accentYellow,
    foregroundColor: primaryDark,
    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    elevation: 0,
  );

  // ===== Style tombol sekunder (abu) — panggil manual: style: AppTheme.secondaryButtonStyle =====
  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: accentGrey,
    foregroundColor: white,
    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    elevation: 0,
  );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: primaryDark,
      colorScheme: const ColorScheme.light(
        primary: primaryDark,
        secondary: accentYellow,
        error: error,
      ),
      appBarTheme: AppBarTheme(
        // Warna solid fallback; untuk AppBar bergradasi bungkus halaman
        // dengan GradientScaffold (lihat gradient_background.dart)
        backgroundColor: primaryDark,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        color: white,
      ),
      textTheme: textTheme,
    );
  }
}
