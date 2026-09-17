// =========================================================
// api_config.dart
// GANTI baseUrl sesuai environment testing kalian:
//
// - Android Emulator  -> "http://10.0.2.2/api_eclipseops"
// - iOS Simulator     -> "http://localhost/api_eclipseops"
// - HP fisik (WiFi sama dgn laptop) -> "http://<IP_LAPTOP>/api_eclipseops"
//   (cari IP laptop dengan `ipconfig` di Windows atau `ifconfig` di Mac/Linux)
// =========================================================

class ApiConfig {
  static const String baseUrl = "http://10.0.2.2/api_eclipseops";
}
