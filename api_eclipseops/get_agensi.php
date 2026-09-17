<?php
// =========================================================
// get_agensi.php
// GET http://localhost/api_eclipseops/get_agensi.php
// Dipakai buat isi dropdown "Label Agensi" di form tambah/edit konser
// =========================================================

require_once "koneksi.php";

$result = $conn->query("SELECT * FROM agensi ORDER BY nama_agensi ASC");
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(["success" => true, "data" => $data]);

$conn->close();
?>
