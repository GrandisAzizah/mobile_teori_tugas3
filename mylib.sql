CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS buku (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(150) NOT NULL,
  penulis VARCHAR(100),
  tahun_terbit INT,
  kategori VARCHAR(50),
  status ENUM('tersedia', 'dipinjam') DEFAULT 'tersedia',
  dipinjam_oleh VARCHAR(100) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS anggota (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  nim VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO users (nama, email, password) VALUES
('Anind', 'anind@example.com', '$2y$10$examplehash1234567890abcdefghijklmnopqrstuv');

INSERT INTO buku (judul, penulis, tahun_terbit, kategori, status, dipinjam_oleh) VALUES
('Keajaiban Toko Kelontong Namiya', 'Keigo Higashino', 2012, 'Fiksi', 'tersedia', NULL),
('Laut Bercerita', 'Leila S. Chudori', 2017, 'Fiksi', 'dipinjam', 'Budi Santoso'),
('Almond', 'Sohn Won-pyung', 2017, 'Fiksi', 'tersedia', NULL),
('Seporsi Mie Ayam Sebelum Mati', 'Brian Khrisna', 2022, 'Fiksi', 'tersedia', NULL),
('Toko Penjual Mimpi', 'Lee Mi-ye', 2020, 'Fiksi Fantasi', 'dipinjam', 'Siti Rahma'),
('Botchan', 'Natsume Soseki', 1906, 'Klasik', 'tersedia', NULL),
('Pangeran Kecil (The Little Prince)', 'Antoine de Saint-Exupéry', 1943, 'Klasik', 'tersedia', NULL),
('Hello Cello', 'Nadia Ristivani', 2023, 'Romantis', 'tersedia', NULL),
('Atomic Habits', 'James Clear', 2018, 'Self Improvement', 'dipinjam', 'Andi Wijaya'),
('Bumi', 'Tere Liye', 2014, 'Fiksi Fantasi', 'tersedia', NULL),
('Bulan', 'Tere Liye', 2015, 'Fiksi Fantasi', 'tersedia', NULL),
('Matahari', 'Tere Liye', 2016, 'Fiksi Fantasi', 'tersedia', NULL),
('Bintang', 'Tere Liye', 2017, 'Fiksi Fantasi', 'dipinjam', 'Dewi Lestari'),
('Cantik Itu Luka', 'Eka Kurniawan', 2002, 'Fiksi', 'tersedia', NULL),
('Bumi Manusia', 'Pramoedya Ananta Toer', 1980, 'Fiksi Sejarah', 'dipinjam', 'Rian Hidayat'),
('Gadis Kretek', 'Ratih Kumala', 2012, 'Fiksi Sejarah', 'tersedia', NULL),
('Kim Ji-young, Lahir Tahun 1982', 'Cho Nam-joo', 2016, 'Fiksi Sosial', 'dipinjam', 'Nina Kartika'),
('Toko Buku Hyunam-dong yang Menentramkan', 'Hwang Bo-reum', 2022, 'Fiksi', 'tersedia', NULL),
('Keberanian Untuk Tidak Disukai', 'Ichiro Kishimi & Fumitake Koga', 2013, 'Self Improvement', 'tersedia', NULL),
('Filosofi Teras', 'Henry Manampiring', 2018, 'Self Improvement', 'dipinjam', 'Eko Prasetyo'),
('Sebuah Seni untuk Bersikap Bodo Amat', 'Mark Manson', 2016, 'Self Improvement', 'tersedia', NULL),
('Bicara Itu Ada Seninya', 'Oh Su-hyang', 2016, 'Self Improvement', 'tersedia', NULL),
('Aku Bukannya Menyerah, Hanya Sedang Lelah', 'Geulbaewoo', 2019, 'Self Improvement', 'tersedia', NULL),
('Home Sweet Loan', 'Almira Bastari', 2022, 'Fiksi', 'dipinjam', 'Fajar Pratama'),
('Nanti Kita Cerita Tentang Hari Ini', 'Marchella FP', 2018, 'Self Improvement', 'tersedia', NULL),
('I Want to Die but I Want to Eat Tteokbokki', 'Baek Se-hee', 2018, 'Self Improvement', 'dipinjam', 'Dian Sastro'),
('Teka-Teki Rumah Anane', 'Keigo Higashino', 2019, 'Misteri', 'tersedia', NULL),
('Kesetiaan Mr. X (The Devotion of Suspect X)', 'Keigo Higashino', 2005, 'Misteri', 'tersedia', NULL),
('Daftar Kematian (Death Note: Another Note)', 'Nisio Isin', 2006, 'Misteri', 'tersedia', NULL),
('Hujan', 'Tere Liye', 2016, 'Fiksi', 'dipinjam', 'Rizky Febian'),
('Pulang', 'Leila S. Chudori', 2012, 'Fiksi Sejarah', 'tersedia', NULL);

INSERT INTO anggota (nama, nim) VALUES
('Grandis Nur Azizah', '124240045'),
('Chairun Feyza Hersa Putri', '124240105'),
('Anindya Zahir Adianputri', '124240113'),
('Rara Ayu Pratiwi', '124240151');