<?php

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$conn = new mysqli('localhost', 'root', '', 'eclipse');
$conn->set_charset('utf8mb4');

$users = [
    [
        'nama' => 'Administrator EclipseOps',
        'email' => 'admin@eclipseops.test',
        'password' => 'admin123',
    ],
    [
        'nama' => 'Staff EclipseOps',
        'email' => 'staff@eclipseops.test',
        'password' => 'staff123',
    ],
];

$check = $conn->prepare('SELECT id FROM users WHERE email = ?');
$insert = $conn->prepare('INSERT INTO users (nama, email, password) VALUES (?, ?, ?)');

foreach ($users as $user) {
    $check->bind_param('s', $user['email']);
    $check->execute();

    if ($check->get_result()->num_rows > 0) {
        echo "Lewati {$user['email']} (sudah ada)\n";
        continue;
    }

    $hashedPassword = password_hash($user['password'], PASSWORD_DEFAULT);
    $insert->bind_param('sss', $user['nama'], $user['email'], $hashedPassword);
    $insert->execute();
    echo "Tambah {$user['email']}\n";
}

$check->close();
$insert->close();
$conn->close();

echo "Seeder users selesai.\n";
