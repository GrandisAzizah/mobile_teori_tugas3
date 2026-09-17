<?php
// =========================================================
// get_konser.php
// GET http://localhost/api_eclipseops/get_konser.php
// =========================================================

require_once "koneksi.php";

$sql = "SELECT konser.*, agensi.nama_agensi
        FROM konser
        LEFT JOIN agensi ON konser.agensi_id = agensi.id
        ORDER BY konser.tanggal ASC";

$result = $conn->query($sql);
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(["success" => true, "data" => $data]);

$conn->close();
?>
