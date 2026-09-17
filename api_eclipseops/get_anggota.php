<?php
// =========================================================
// get_anggota.php
// GET http://localhost/api_eclipseops/get_anggota.php
// Dipakai untuk menu "Daftar Staff" (jobdesc Orang B)
// =========================================================

require_once "koneksi.php";

$result = $conn->query("SELECT * FROM anggota ORDER BY id ASC");
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(["success" => true, "data" => $data]);

$conn->close();
?>
