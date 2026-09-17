<?php
// =========================================================
// login.php
// POST http://localhost/api_eclipseops/login.php
// Body (x-www-form-urlencoded): email, password
// =========================================================

require_once "koneksi.php";

$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode(["success" => false, "message" => "Email dan password wajib diisi"]);
    exit();
}

$stmt = $conn->prepare("SELECT id, nama, email, password FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["success" => false, "message" => "Email atau password salah"]);
    exit();
}

$user = $result->fetch_assoc();

if (password_verify($password, $user['password'])) {
    unset($user['password']);
    echo json_encode([
        "success" => true,
        "message" => "Login berhasil",
        "user" => $user
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Email atau password salah"]);
}

$stmt->close();
$conn->close();
?>
