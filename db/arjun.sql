-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 14, 2017 at 10:51 AM
-- Server version: 10.1.13-MariaDB
-- PHP Version: 5.6.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `arjun`
--
CREATE DATABASE IF NOT EXISTS `arjun` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `arjun`;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `noisbn` decimal(13,0) NOT NULL,
  `penulis` varchar(50) NOT NULL,
  `penerbit` varchar(50) NOT NULL,
  `tahun` year(4) NOT NULL,
  `stok` int(5) NOT NULL,
  `harga_pokok` decimal(10,0) NOT NULL,
  `harga_jual` decimal(10,0) NOT NULL,
  `ppn` int(2) NOT NULL,
  `diskon` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `noisbn`, `penulis`, `penerbit`, `tahun`, `stok`, `harga_pokok`, `harga_jual`, `ppn`, `diskon`) VALUES
(1, 'How to Basic', '123456789', 'Djoen', 'NRM', 2017, 120, '30000', '35000', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `distributor`
--

CREATE TABLE `distributor` (
  `id_distributor` int(11) NOT NULL,
  `nama_distributor` varchar(50) NOT NULL,
  `alamat` varchar(255) NOT NULL,
  `telepon` varchar(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `distributor`
--

INSERT INTO `distributor` (`id_distributor`, `nama_distributor`, `alamat`, `telepon`) VALUES
(1, 'Djoen', 'Jl. jawa', '087785188663');

-- --------------------------------------------------------

--
-- Table structure for table `kasir`
--

CREATE TABLE `kasir` (
  `id_kasir` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `alamat` varchar(255) NOT NULL,
  `telepon` varchar(13) NOT NULL,
  `status` varchar(12) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `akses` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kasir`
--

INSERT INTO `kasir` (`id_kasir`, `nama`, `alamat`, `telepon`, `status`, `username`, `password`, `akses`) VALUES
(1, 'Djoen', 'Jl. Jawa', '087785188663', 'Aktif', 'LastApril', 'LastApril96', 'Admin'),
(2, 'Arjun Hamdalah', 'Jl. Masjid Al-Muawanah', '089698336298', 'Aktif', '161099', 'Arjun', 'Kasir');

-- --------------------------------------------------------

--
-- Table structure for table `pasok`
--

CREATE TABLE `pasok` (
  `id_pasok` int(11) NOT NULL,
  `id_distributor` int(11) NOT NULL,
  `id_buku` int(11) NOT NULL,
  `jumlah` int(5) NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pasok`
--

INSERT INTO `pasok` (`id_pasok`, `id_distributor`, `id_buku`, `jumlah`, `tanggal`) VALUES
(1, 1, 1, 100, '2017-02-14'),
(2, 1, 1, 10, '2017-02-01'),
(3, 1, 1, 10, '2017-02-13');

--
-- Triggers `pasok`
--
DELIMITER $$
CREATE TRIGGER `kurang stok` AFTER DELETE ON `pasok` FOR EACH ROW UPDATE buku SET
buku.stok = buku.stok - OLD.jumlah
WHERE buku.id_buku = OLD.id_buku
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `nambah stok` AFTER INSERT ON `pasok` FOR EACH ROW UPDATE buku SET
buku.stok = buku.stok + NEW.jumlah
WHERE buku.id_buku = NEW.id_buku
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update stok` AFTER UPDATE ON `pasok` FOR EACH ROW UPDATE buku SET
buku.stok = buku.stok - OLD.jumlah + NEW.jumlah
WHERE buku.id_buku = OLD.id_buku
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `penjualan`
--

CREATE TABLE `penjualan` (
  `id_penjualan` int(11) NOT NULL,
  `id_buku` int(11) NOT NULL,
  `id_kasir` int(11) NOT NULL,
  `jumlah` int(5) NOT NULL,
  `total` decimal(10,0) NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `penjualan`
--

INSERT INTO `penjualan` (`id_penjualan`, `id_buku`, `id_kasir`, `jumlah`, `total`, `tanggal`) VALUES
(1, 1, 1, 15, '350000', '2017-02-14'),
(2, 1, 1, 5, '175000', '2017-02-13');

--
-- Triggers `penjualan`
--
DELIMITER $$
CREATE TRIGGER `kurang stok buku abis jual` AFTER INSERT ON `penjualan` FOR EACH ROW UPDATE buku SET
buku.stok = buku.stok - NEW.jumlah
WHERE buku.id_buku = NEW.id_buku
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambah stok` AFTER DELETE ON `penjualan` FOR EACH ROW UPDATE buku SET
buku.stok = buku.stok + OLD.jumlah
WHERE buku.id_buku = OLD.id_buku
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ubah stok sesuai penjualan` AFTER UPDATE ON `penjualan` FOR EACH ROW UPDATE buku SET
buku.stok = buku.stok - OLD.jumlah + NEW.jumlah
WHERE buku.id_buku = OLD.id_buku
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indexes for table `distributor`
--
ALTER TABLE `distributor`
  ADD PRIMARY KEY (`id_distributor`);

--
-- Indexes for table `kasir`
--
ALTER TABLE `kasir`
  ADD PRIMARY KEY (`id_kasir`);

--
-- Indexes for table `pasok`
--
ALTER TABLE `pasok`
  ADD PRIMARY KEY (`id_pasok`);

--
-- Indexes for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`id_penjualan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `distributor`
--
ALTER TABLE `distributor`
  MODIFY `id_distributor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `kasir`
--
ALTER TABLE `kasir`
  MODIFY `id_kasir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `pasok`
--
ALTER TABLE `pasok`
  MODIFY `id_pasok` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `penjualan`
--
ALTER TABLE `penjualan`
  MODIFY `id_penjualan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
