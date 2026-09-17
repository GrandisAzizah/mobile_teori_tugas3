<?php
// =========================================================
// koneksi.php
// Menghubungkan PHP ke database MySQL "eclipse" (sesuai
// nama database yang dipakai saat import eclipse.sql).
// Kalau nama database kalian beda, ganti $dbname di bawah.
// =========================================================

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");

$host = "localhost";
$user = "root";
$pass = "";
$dbname = "eclipse"; // sesuaikan dengan nama database di phpMyAdmin

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Koneksi database gagal: " . $conn->connect_error
    ]);
    exit();
}

$conn->set_charset("utf8mb4");
?>
