<?php
// =========================================================
// register.php
// POST http://localhost/api_eclipseops/register.php
// Body (x-www-form-urlencoded): nama, email, password
// =========================================================

require_once "koneksi.php";

$nama = $_POST['nama'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

if (empty($nama) || empty($email) || empty($password)) {
    echo json_encode(["success" => false, "message" => "Semua field wajib diisi"]);
    exit();
}

$cek = $conn->prepare("SELECT id FROM users WHERE email = ?");
$cek->bind_param("s", $email);
$cek->execute();
$hasil = $cek->get_result();

if ($hasil->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "Email sudah terdaftar"]);
    exit();
}

$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

$stmt = $conn->prepare("INSERT INTO users (nama, email, password) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $nama, $email, $hashedPassword);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Registrasi berhasil"]);
} else {
    echo json_encode(["success" => false, "message" => "Registrasi gagal: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
