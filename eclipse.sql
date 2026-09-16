CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE agensi (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_agensi VARCHAR(100) NOT NULL,
  keterangan VARCHAR(255)
);

CREATE TABLE konser (
  id INT AUTO_INCREMENT PRIMARY KEY,
  agensi_id INT,
  nama_konser VARCHAR(150) NOT NULL,
  nama_grup VARCHAR(100),
  tanggal DATE,
  venue VARCHAR(150),
  kapasitas INT,
  tiket_terjual INT DEFAULT 0,
  harga_tiket DECIMAL(10,2),
  status ENUM('akan_datang','selesai','dibatalkan') DEFAULT 'akan_datang',
  FOREIGN KEY (agensi_id) REFERENCES agensi(id)
);


CREATE TABLE anggota (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  nim VARCHAR(20) NOT NULL,
  UNIQUE(nim)
);

INSERT INTO agensi (nama_agensi, keterangan) VALUES
('BigHit Music', 'Label utama HYBE'),
('Pledis Entertainment', 'Sub-label HYBE'),
('ADOR', 'Sub-label HYBE'),
('Source Music', 'Sub-label HYBE'),
('KOZ Entertainment', 'Sub-label HYBE'),
('Belift Lab', 'Sub-label HYBE');

INSERT INTO konser (agensi_id, nama_konser, nama_grup, tanggal, venue, kapasitas, tiket_terjual, harga_tiket, status) VALUES
(1, 'World Tour Jakarta Leg', 'BTS', '2026-11-15', 'Gelora Bung Karno, Jakarta', 50000, 42000, 1500000.00, 'akan_datang'),
(1, 'Fan Concert Seoul', 'BTS', '2026-10-02', 'KSPO Dome, Seoul', 15000, 15000, 900000.00, 'akan_datang'),
(1, 'Comeback Showcase', 'TOMORROW X TOGETHER', '2026-09-20', 'Blue Square, Seoul', 3000, 2750, 500000.00, 'selesai'),
(1, 'Asia Tour Manila Leg', 'TOMORROW X TOGETHER', '2026-12-05', 'Mall of Asia Arena, Manila', 15000, 9800, 1300000.00, 'akan_datang'),
(2, 'Special Stage Tokyo', 'SEVENTEEN', '2026-12-01', 'Tokyo Dome, Tokyo', 40000, 18000, 1800000.00, 'akan_datang'),
(2, 'World Tour Bangkok Leg', 'SEVENTEEN', '2026-10-18', 'Impact Arena, Bangkok', 25000, 25000, 1400000.00, 'selesai'),
(2, 'Mini Fanmeeting', 'fromis_9', '2026-08-10', 'Sabuga, Bandung', 5000, 0, 750000.00, 'dibatalkan'),
(2, 'Debut Anniversary Stage', 'TWS', '2026-09-05', 'Inspire Arena, Incheon', 12000, 12000, 1200000.00, 'selesai'),
(3, 'Bunnies Camp Concert', 'NewJeans', '2026-11-22', 'KSPO Dome, Seoul', 20000, 19500, 1350000.00, 'akan_datang'),
(3, 'Asia Tour Jakarta Leg', 'NewJeans', '2026-12-20', 'Indonesia Arena, Jakarta', 18000, 5000, 1600000.00, 'akan_datang'),
(4, 'World Tour Singapore Leg', 'LE SSERAFIM', '2026-10-30', 'Singapore Indoor Stadium', 12000, 12000, 1450000.00, 'selesai'),
(4, 'Fan Concert Seoul', 'LE SSERAFIM', '2026-11-08', 'KSPO Dome, Seoul', 15000, 13200, 1100000.00, 'akan_datang'),
(5, 'Solo Concert Seoul', 'ZICO', '2026-09-14', 'YES24 Live Hall, Seoul', 4000, 3900, 950000.00, 'selesai'),
(6, 'Global Tour Jakarta Leg', 'ENHYPEN', '2026-11-29', 'Indonesia Arena, Jakarta', 20000, 20000, 1700000.00, 'akan_datang'),
(6, 'World Tour Kuala Lumpur Leg', 'ENHYPEN', '2026-10-11', 'Axiata Arena, Kuala Lumpur', 15000, 14500, 1350000.00, 'selesai'),
(6, 'Debut Showcase', 'ILLIT', '2026-08-25', 'Blue Square, Seoul', 3000, 3000, 550000.00, 'selesai'),
(6, 'First Fan Concert', 'ILLIT', '2026-12-12', 'KSPO Dome, Seoul', 10000, 4200, 1000000.00, 'akan_datang');

INSERT INTO anggota (nama, nim) VALUES
('Grandis Nur Azizah', '124240045'),
('Chairun Feyza Hersa Putri', '124240105'),
('Anindya Zahir Adianputri', '124240113'),
('Rara Ayu Pratiwi', '124240151');