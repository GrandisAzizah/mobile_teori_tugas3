<?php
// =========================================================
// edit_konser.php
// POST http://localhost/api_eclipseops/edit_konser.php
// Body: id, agensi_id, nama_konser, nama_grup, tanggal,
//       venue, kapasitas, tiket_terjual, harga_tiket, status
// =========================================================

require_once "koneksi.php";

$id = $_POST['id'] ?? '';
$agensi_id = $_POST['agensi_id'] ?? null;
$nama_konser = $_POST['nama_konser'] ?? '';
$nama_grup = $_POST['nama_grup'] ?? '';
$tanggal = $_POST['tanggal'] ?? null;
$venue = $_POST['venue'] ?? '';
$kapasitas = $_POST['kapasitas'] ?? 0;
$tiket_terjual = $_POST['tiket_terjual'] ?? 0;
$harga_tiket = $_POST['harga_tiket'] ?? 0;
$status = $_POST['status'] ?? 'akan_datang';

if (empty($id)) {
    echo json_encode(["success" => false, "message" => "ID konser wajib diisi"]);
    exit();
}

$stmt = $conn->prepare(
    "UPDATE konser SET agensi_id=?, nama_konser=?, nama_grup=?, tanggal=?, venue=?,
     kapasitas=?, tiket_terjual=?, harga_tiket=?, status=? WHERE id=?"
);
$stmt->bind_param(
    "issssiidsi",
    $agensi_id, $nama_konser, $nama_grup, $tanggal, $venue, $kapasitas, $tiket_terjual, $harga_tiket, $status, $id
);
// Urutan tipe (10 parameter): i=agensi_id, s=nama_konser, s=nama_grup, s=tanggal,
// s=venue, i=kapasitas, i=tiket_terjual, d=harga_tiket, s=status, i=id
// -> "issssiidsi" (10 karakter). Sesuaikan lagi kalau field berubah.

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Konser berhasil diupdate"]);
} else {
    echo json_encode(["success" => false, "message" => "Gagal update konser: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
