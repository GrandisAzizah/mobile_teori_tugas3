<?php
// =========================================================
// tambah_konser.php
// POST http://localhost/api_eclipseops/tambah_konser.php
// Body: agensi_id, nama_konser, nama_grup, tanggal (yyyy-MM-dd),
//       venue, kapasitas, tiket_terjual, harga_tiket, status
// =========================================================

require_once "koneksi.php";

$agensi_id = $_POST['agensi_id'] ?? null;
$nama_konser = $_POST['nama_konser'] ?? '';
$nama_grup = $_POST['nama_grup'] ?? '';
$tanggal = $_POST['tanggal'] ?? null;
$venue = $_POST['venue'] ?? '';
$kapasitas = $_POST['kapasitas'] ?? 0;
$tiket_terjual = $_POST['tiket_terjual'] ?? 0;
$harga_tiket = $_POST['harga_tiket'] ?? 0;
$status = $_POST['status'] ?? 'akan_datang';

if (empty($nama_konser)) {
    echo json_encode(["success" => false, "message" => "Nama konser wajib diisi"]);
    exit();
}

$stmt = $conn->prepare(
    "INSERT INTO konser (agensi_id, nama_konser, nama_grup, tanggal, venue, kapasitas, tiket_terjual, harga_tiket, status)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
);
$stmt->bind_param(
    "issssiids",
    $agensi_id, $nama_konser, $nama_grup, $tanggal, $venue, $kapasitas, $tiket_terjual, $harga_tiket, $status
);
// Urutan tipe: i=agensi_id, s=nama_konser, s=nama_grup, s=tanggal, s=venue,
// i=kapasitas, i=tiket_terjual, d=harga_tiket, s=status -> "issssiids" (9 karakter)
// Kalau field ditambah/dikurangi, sesuaikan lagi jumlah & urutan huruf ini.

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Konser berhasil ditambahkan", "id" => $stmt->insert_id]);
} else {
    echo json_encode(["success" => false, "message" => "Gagal menambah konser: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
