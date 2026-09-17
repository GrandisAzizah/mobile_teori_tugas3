<?php
// =========================================================
// hapus_konser.php
// POST http://localhost/api_eclipseops/hapus_konser.php
// Body: id
// =========================================================

require_once "koneksi.php";

$id = $_POST['id'] ?? '';

if (empty($id)) {
    echo json_encode(["success" => false, "message" => "ID konser wajib diisi"]);
    exit();
}

$stmt = $conn->prepare("DELETE FROM konser WHERE id = ?");
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Konser berhasil dihapus"]);
} else {
    echo json_encode(["success" => false, "message" => "Gagal menghapus konser: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
