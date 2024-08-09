-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 28 Ara 2023, 11:55:37
-- Sunucu sürümü: 10.4.28-MariaDB
-- PHP Sürümü: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `sanalmarket`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Aylik Maas Gideri Hesabi` ()   SELECT SUM(maas) AS AylikMaasGideri
FROM calisanlar$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Calisan Ad Arama ve Pozisyon Listeleme` (IN `kelime` VARCHAR(255))   SELECT calisanlar.calisan_id, calisanlar.ad_soyad, pozisyonlar.pozisyon, calisanlar.maas FROM calisanlar, pozisyonlar
WHERE calisanlar.pozisyon_id = pozisyonlar.pozisyon_id
AND ad_soyad LIKE CONCAT('%', kelime, '%')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Calısan Ad ve Pozisyonlarini Listeleme` ()   SELECT calisanlar.ad_soyad, pozisyonlar.pozisyon
FROM calisanlar
JOIN pozisyonlar ON calisanlar.pozisyon_id = pozisyonlar.pozisyon_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Fiyat Araliginda Urun Siralama` (IN `minFiyat` INT, IN `maxFiyat` INT)   SELECT urun_id, urun_ad, fiyat, urun_kategori.urun_kategori
FROM urunler, urun_kategori
WHERE urunler.urun_kategori_id = urun_kategori.urun_kategori_id AND urunler.fiyat BETWEEN minFiyat AND maxFiyat ORDER BY urunler.fiyat ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ID ile Musteri ve Siparislerini Listeleme` (IN `musteriID` INT)   SELECT siparisler.siparis_id, musteriler.ad_soyad, siparisler.tarih, siparisler.toplam_fiyat
FROM musteriler, siparisler
WHERE musteriler.musteri_id = siparisler.musteri_id
AND musteriler.musteri_id = musteriID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `iki Tarih Arasi Toplam Ciro` (IN `baslangicTarih` DATE, IN `bitisTarih` DATE)   SELECT COUNT(siparis_id) AS siparis_sayisi, SUM(toplam_fiyat) AS toplam_para
FROM siparisler
WHERE tarih BETWEEN baslangicTarih AND bitisTarih$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `iki Tarih Arası Toplam Satis` (IN `baslangicTarih` DATE, IN `bitisTarih` DATE)   SELECT COUNT(*) AS SiparisSayisi
FROM siparisler
WHERE tarih BETWEEN baslangicTarih AND bitisTarih$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Kategori Fiyat Ortalamasi` (IN `kategoriAd` VARCHAR(255))   SELECT urun_kategori.urun_kategori, AVG(urunler.fiyat) AS Kategori_Ortalama_Fiyatı
FROM urunler,urun_kategori
WHERE urunler.urun_kategori_id = urun_kategori.urun_kategori_id
AND urun_kategori.urun_kategori = kategoriAd$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Kullanici Degerine Gore Kategori Urun Sayisi Listeleme` (IN `sayi` INT)   SELECT urunler.urun_kategori_id, urun_kategori.urun_kategori, COUNT(*) AS urun_sayisi
FROM urunler
JOIN urun_kategori ON urun_kategori.urun_kategori_id = urunler.urun_kategori_id
GROUP BY urunler.urun_kategori_id, urun_kategori.urun_kategori
HAVING COUNT(*) > sayi$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Musteri Siparis Adedini Listeleme` ()   SELECT musteriler.ad_soyad, COUNT(siparisler.siparis_id) AS siparis_sayisi
FROM musteriler
LEFT JOIN siparisler ON musteriler.musteri_id = siparisler.musteri_id
GROUP BY musteriler.ad_soyad$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Musteri Siparis Adres Durum Listeleme` ()   SELECT musteriler.ad_soyad, musteriler.adres ,durumlar.durum
FROM musteriler
JOIN siparisler ON musteriler.musteri_id = siparisler.musteri_id
JOIN durumlar ON siparisler.durum_id = durumlar.durum_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Urun Fiyat/indirim Miktari/indirimli Fiyat Listeleme` ()   SELECT
	urunler.urun_id AS 'Ürün ID',
    urunler.urun_ad AS 'Ürün Adı',
    urunler.fiyat AS 'İndirimsiz Fiyat',
    indirimler.indirim_miktar AS 'İndirim Miktarı',
    (urunler.fiyat - indirimler.indirim_miktar) AS 'İndirimli Fiyat'
    FROM urunler, indirimler
	WHERE urunler.urun_id = indirimler.urun_id$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `calisanlar`
--

CREATE TABLE `calisanlar` (
  `calisan_id` int(11) NOT NULL,
  `ad_soyad` varchar(255) DEFAULT NULL,
  `pozisyon_id` int(11) DEFAULT NULL,
  `maas` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `calisanlar`
--

INSERT INTO `calisanlar` (`calisan_id`, `ad_soyad`, `pozisyon_id`, `maas`) VALUES
(28, 'Mehmet Yılmaz', 1, 100000),
(29, 'Ayşe Kaya', 7, 60000),
(30, 'Ali Demir', 5, 55000),
(31, 'Zeynep Aksoy', 2, 48000),
(32, 'Murat Çelik', 9, 70000),
(33, 'Fatma Öztürk', 4, 52000),
(34, 'Ahmet Gündoğdu', 8, 65000),
(35, 'Sevgi Kılıç', 3, 45000),
(36, 'İsmail Başaran', 6, 58000),
(37, 'Gamze Erdoğan', 10, 75000),
(38, 'Mustafa Arslan', 3, 50000),
(39, 'Elif Yıldırım', 7, 60000),
(40, 'Emre Doğan', 5, 55000),
(41, 'Selma Tekin', 2, 48000),
(42, 'Hüseyin Yılmaz', 9, 70000),
(43, 'Melis Aktaş', 4, 52000),
(44, 'Onur Şen', 8, 65000),
(45, 'Esra Yıldız', 8, 45000),
(46, 'Kadir Akbulut', 6, 58000),
(47, 'Nihan Atalay', 10, 75000),
(48, 'Serkan Yıldırım', 3, 50000),
(49, 'Elif Öztürk', 7, 60000),
(50, 'Emre Şahin', 5, 55000),
(51, 'Zeynep Gürsoy', 2, 48000),
(52, 'Ahmet Yıldız', 9, 70000),
(53, 'Seda Demir', 4, 52000),
(54, 'Can Kaya', 8, 65000);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `durumlar`
--

CREATE TABLE `durumlar` (
  `durum_id` int(11) NOT NULL,
  `durum` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `durumlar`
--

INSERT INTO `durumlar` (`durum_id`, `durum`) VALUES
(1, 'Hazırlanıyor'),
(2, 'Kargoda'),
(3, 'Ulaştırıldı'),
(4, 'İade Edildi');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `indirimler`
--

CREATE TABLE `indirimler` (
  `indirim_id` int(11) NOT NULL,
  `urun_id` int(11) DEFAULT NULL,
  `indirim_miktar` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `indirimler`
--

INSERT INTO `indirimler` (`indirim_id`, `urun_id`, `indirim_miktar`) VALUES
(1, 1, 1),
(2, 3, 2),
(3, 5, 1),
(4, 7, 3),
(5, 9, 2),
(6, 11, 1),
(7, 13, 4),
(8, 15, 2),
(9, 17, 1),
(10, 19, 3),
(11, 21, 2),
(12, 23, 1),
(13, 25, 2),
(14, 27, 2),
(15, 29, 1),
(16, 31, 3),
(17, 33, 1),
(18, 35, 2),
(19, 37, 1),
(20, 39, 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `musteriler`
--

CREATE TABLE `musteriler` (
  `musteri_id` int(11) NOT NULL,
  `ad_soyad` varchar(255) DEFAULT NULL,
  `eposta` varchar(255) DEFAULT NULL,
  `telefon_no` varchar(255) DEFAULT NULL,
  `adres` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `musteriler`
--

INSERT INTO `musteriler` (`musteri_id`, `ad_soyad`, `eposta`, `telefon_no`, `adres`) VALUES
(1, 'Mehmet Yılmaz', 'mehmet.yilmaz@email.com', '0555 123 45 67', 'İstanbul, Kadıköy, Moda Caddesi No: 123'),
(2, 'Ayşe Kaya', 'ayse.kaya@email.com', '0532 987 65 43', 'Ankara, Çankaya, Gazi Caddesi No: 56'),
(3, 'Ali Demir', 'ali.demir@email.com', '0543 654 32 10', 'İzmir, Alsancak, Atatürk Bulvarı No: 78'),
(4, 'Zeynep Aksoy', 'zeynep.aksoy@email.com', '0530 876 54 32', 'Bursa, Nilüfer, Cemal Nadir Sokak No: 34'),
(5, 'Murat Çelik', 'murat.celik@email.com', '0551 234 56 78', 'Adana, Seyhan, Atatürk Caddesi No: 90'),
(6, 'Fatma Öztürk', 'fatma.ozturk@email.com', '0534 876 54 32', 'Antalya, Muratpaşa, Barbaros Bulvarı No: 21'),
(7, 'Ahmet Gündoğdu', 'ahmet.gundogdu@email.com', '0552 345 67 89', 'Eskişehir, Tepebaşı, İsmet İnönü Caddesi No: 43'),
(8, 'Sevgi Kılıç', 'sevgi.kilic@email.com', '0536 987 65 43', 'Trabzon, Ortahisar, Fatih Caddesi No: 12'),
(9, 'İsmail Başaran', 'ismail.basaran@email.com', '0553 654 32 10', 'Gaziantep, Şahinbey, Cumhuriyet Bulvarı No: 67'),
(10, 'Gamze Erdoğan', 'gamze.erdogan@email.com', '0531 876 54 32', 'Mersin, Akdeniz, İnönü Caddesi No: 45'),
(11, 'Mustafa Arslan', 'mustafa.arslan@email.com', '0554 234 56 78', 'Samsun, İlkadım, Gazi Caddesi No: 89'),
(12, 'Elif Yıldırım', 'elif.yildirim@email.com', '0535 876 54 32', 'Denizli, Merkez, İstiklal Caddesi No: 32'),
(13, 'Emre Doğan', 'emre.dogan@email.com', '0555 345 67 89', 'Konya, Selçuklu, Mevlana Bulvarı No: 78'),
(14, 'Selma Tekin', 'selma.tekin@email.com', '0533 987 65 43', 'Kayseri, Kocasinan, Talas Caddesi No: 56'),
(15, 'Hüseyin Yılmaz', 'huseyin.yilmaz@gmail.com', '0556 654 32 10', 'Şanlıurfa, Haliliye, Atatürk Bulvarı No: 34'),
(16, 'Melis Aktaş', 'melis.aktas@email.com', '0537 876 54 32', 'Diyarbakır, Bağlar, İnönü Caddesi No: 90'),
(17, 'Onur Şen', 'onur.sen@email.com', '0556 234 56 78', 'Hatay, Antakya, İstiklal Caddesi No: 21'),
(18, 'Esra Yıldız', 'esra.yildiz@email.com', '0538 987 65 43', 'Tekirdağ, Merkez, Gazi Caddesi No: 43'),
(20, 'Nihan Atalay', 'nihan.atalay@email.com', '0539 876 54 32', 'Çanakkale, Merkez, İnönü Caddesi No: 67'),
(21, 'Serkan Yıldırım', 'serkan.yildirim@email.com', '0558 234 56 78', 'Nevşehir, Merkez, Atatürk Bulvarı No: 45'),
(22, 'Elif Öztürk', 'elif.ozturk@email.com', '0540 987 65 43', 'Sivas, Merkez, Gazi Caddesi No: 32'),
(23, 'Emre Şahin', 'emre.sahin@email.com', '0559 654 32 10', 'Kocaeli, İzmit, Mevlana Bulvarı No: 56'),
(24, 'Zeynep Gürsoy', 'zeynep.gursoy@email.com', '0540 123 45 67', 'İstanbul, Beşiktaş, Barbaros Caddesi No: 45'),
(28, 'Orçun Gocaoğlu', 'orcungocaoglu@hotmail.com', '531 665 59 05', NULL);

--
-- Tetikleyiciler `musteriler`
--
DELIMITER $$
CREATE TRIGGER `musteri_ekle_trigger` AFTER INSERT ON `musteriler` FOR EACH ROW INSERT INTO musteri_eklenen (musteri_id, eklenme_tarihi)
VALUES (NEW.musteri_id, NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `musteri_silme_trigger` BEFORE DELETE ON `musteriler` FOR EACH ROW INSERT INTO musteri_silinen (musteri_id, ad_soyad, eposta, telefon_no, adres, silinme_tarihi)
VALUES (OLD.musteri_id, OLD.ad_soyad, OLD.eposta, OLD.telefon_no, OLD.adres , NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `musteri_update_trigger` BEFORE UPDATE ON `musteriler` FOR EACH ROW INSERT INTO musteri_update_log (guncellenen_id, guncellenme_tarihi)
VALUES (OLD.musteri_id, NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `musteri_eklenen`
--

CREATE TABLE `musteri_eklenen` (
  `musteri_id` int(11) DEFAULT NULL,
  `eklenme_tarihi` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `musteri_eklenen`
--

INSERT INTO `musteri_eklenen` (`musteri_id`, `eklenme_tarihi`) VALUES
(28, '2023-12-19 01:45:56');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `musteri_silinen`
--

CREATE TABLE `musteri_silinen` (
  `musteri_id` int(11) DEFAULT NULL,
  `ad_soyad` varchar(255) DEFAULT NULL,
  `eposta` varchar(255) DEFAULT NULL,
  `telefon_no` varchar(255) DEFAULT NULL,
  `adres` varchar(255) DEFAULT NULL,
  `silinme_tarihi` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `musteri_silinen`
--

INSERT INTO `musteri_silinen` (`musteri_id`, `ad_soyad`, `eposta`, `telefon_no`, `adres`, `silinme_tarihi`) VALUES
(19, 'Kadir Akbulut', 'kadir.akbulut@email.com', '0557 654 32 10', 'Zonguldak, Merkez, Cumhuriyet Bulvarı No: 12', '2023-12-19 01:47:14');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `musteri_update_log`
--

CREATE TABLE `musteri_update_log` (
  `guncellenen_id` int(11) DEFAULT NULL,
  `guncellenme_tarihi` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `musteri_update_log`
--

INSERT INTO `musteri_update_log` (`guncellenen_id`, `guncellenme_tarihi`) VALUES
(15, '2023-12-19 01:36:46');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `odeme`
--

CREATE TABLE `odeme` (
  `odeme_id` int(11) NOT NULL,
  `siparis_id` int(11) DEFAULT NULL,
  `odeme_tip_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `odeme`
--

INSERT INTO `odeme` (`odeme_id`, `siparis_id`, `odeme_tip_id`) VALUES
(1, 1, 3),
(2, 2, 2),
(3, 3, 1),
(4, 4, 3),
(5, 5, 4),
(6, 6, 2),
(7, 7, 1),
(8, 8, 3),
(9, 9, 4),
(10, 10, 1),
(11, 11, 2),
(12, 12, 2),
(13, 13, 3),
(14, 14, 4),
(15, 15, 2),
(16, 16, 1),
(17, 17, 2),
(18, 18, 3),
(19, 19, 2),
(20, 20, 2);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `odeme_tip`
--

CREATE TABLE `odeme_tip` (
  `odeme_tip_id` int(11) NOT NULL,
  `odeme_tip` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `odeme_tip`
--

INSERT INTO `odeme_tip` (`odeme_tip_id`, `odeme_tip`) VALUES
(1, 'Kapıda Ödeme'),
(2, 'Kredi Kartı'),
(3, 'Faturalı Ödeme'),
(4, 'Mobil Ödeme');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `pozisyonlar`
--

CREATE TABLE `pozisyonlar` (
  `pozisyon_id` int(11) NOT NULL,
  `pozisyon` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `pozisyonlar`
--

INSERT INTO `pozisyonlar` (`pozisyon_id`, `pozisyon`) VALUES
(1, 'Müdür'),
(2, 'Kurye'),
(3, 'Müşteri Temsilcisi'),
(4, 'Lojistik'),
(5, 'Pazarlama ve Reklam'),
(6, 'Güvenlik Uzmanı'),
(7, 'İnsan Kaynakları'),
(8, 'Muhasebe'),
(9, 'Yazılım Mühendisi'),
(10, 'Veri Analisti');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `siparisler`
--

CREATE TABLE `siparisler` (
  `siparis_id` int(11) NOT NULL,
  `musteri_id` int(11) DEFAULT NULL,
  `tarih` date DEFAULT NULL,
  `toplam_fiyat` int(11) DEFAULT NULL,
  `durum_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `siparisler`
--

INSERT INTO `siparisler` (`siparis_id`, `musteri_id`, `tarih`, `toplam_fiyat`, `durum_id`) VALUES
(1, 5, '2023-01-10', 150, 2),
(2, 8, '2023-02-15', 200, 1),
(3, 12, '2023-03-20', 75, 3),
(4, 18, '2023-04-05', 300, 2),
(5, 2, '2023-05-12', 120, 4),
(6, 14, '2023-06-18', 250, 1),
(7, 20, '2023-07-22', 180, 3),
(8, 6, '2023-08-01', 90, 2),
(9, 10, '2023-09-08', 200, 4),
(10, 24, '2023-10-14', 150, 1),
(11, 3, '2023-11-20', 120, 3),
(12, 5, '2023-12-25', 280, 2),
(13, 1, '2023-01-05', 100, 4),
(14, 9, '2023-02-10', 150, 1),
(15, 16, '2023-03-15', 200, 3),
(16, 22, '2023-04-20', 80, 2),
(17, 7, '2023-05-25', 300, 4),
(18, 11, '2023-06-30', 120, 1),
(19, 17, '2023-07-05', 180, 3),
(20, 4, '2023-08-10', 90, 2);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `urunler`
--

CREATE TABLE `urunler` (
  `urun_id` int(11) NOT NULL,
  `urun_ad` varchar(255) DEFAULT NULL,
  `urun_kategori_id` int(11) DEFAULT NULL,
  `fiyat` int(11) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `urunler`
--

INSERT INTO `urunler` (`urun_id`, `urun_ad`, `urun_kategori_id`, `fiyat`, `stok`) VALUES
(1, 'Elma', 1, 3, 100),
(2, 'Domates', 1, 2, 120),
(3, 'Tavuk Göğsü', 2, 16, 50),
(4, 'Somon Balığı', 2, 26, 30),
(5, 'Süt', 3, 4, 80),
(6, 'Kahvaltılık Gevrek', 3, 8, 60),
(7, 'Pirinç', 4, 4, 90),
(8, 'Zeytinyağı', 4, 13, 40),
(9, 'Hamburger', 5, 9, 70),
(10, 'Meyve Suyu', 6, 6, 120),
(11, 'Vanilyalı Dondurma', 7, 11, 25),
(12, 'Cips', 8, 3, 100),
(13, 'Fırın Simit', 9, 5, 150),
(14, 'Çamaşır Deterjanı', 10, 10, 50),
(15, 'Tuvalet Kağıdı', 11, 3, 80),
(16, 'Şampuan', 12, 7, 60),
(17, 'Bebek Bezi', 13, 15, 30),
(18, 'Mop', 14, 19, 20),
(19, 'Defter', 15, 5, 100),
(20, 'Çiçek Buketi', 16, 20, 15),
(21, 'Köpek Maması', 17, 8, 40),
(22, 'Akıllı Telefon', 18, 900, 10),
(23, 'Portakal', 1, 3, 80),
(24, 'Salatalık', 1, 2, 110),
(25, 'Dana Kuymağı', 2, 23, 40),
(26, 'Alabalık', 2, 19, 35),
(27, 'Yoğurt', 3, 3, 90),
(28, 'Bal', 3, 16, 25),
(29, 'Mercimek', 4, 3, 70),
(30, 'Sıvı Yağ', 4, 10, 60),
(31, 'Pizza', 5, 13, 45),
(32, 'Limonata', 6, 4, 100),
(33, 'Çikolatalı Dondurma', 7, 9, 30),
(34, 'Kurabiye', 8, 5, 80),
(35, 'Ekmek', 9, 3, 120),
(36, 'Bulaşık Deterjanı', 10, 7, 50),
(37, 'Peçete', 11, 5, 70),
(38, 'Duş Jeli', 12, 5, 40),
(39, 'Bebek Mama', 13, 10, 20),
(40, 'Süpürge', 14, 25, 15),
(41, 'Kalem', 15, 1, 150),
(42, 'Gül Buketi', 16, 15, 10),
(43, 'Kedi Maması', 17, 6, 35),
(44, 'Laptop', 18, 1300, 5),
(45, 'Armut', 1, 3, 60),
(46, 'Kabak', 1, 1, 80),
(47, 'Tavuk Pirzola', 2, 13, 60),
(48, 'Orkinos Balığı', 2, 29, 20),
(49, 'Çilek', 1, 5, 90),
(50, 'Patates', 1, 1, 110),
(51, 'Dana Kıyma', 2, 20, 45),
(52, 'Hamsi', 2, 16, 30),
(53, 'Yoğurtlu İçecek', 3, 4, 80),
(54, 'Reçel', 3, 9, 55),
(55, 'Bulgur', 4, 4, 70),
(56, 'Sirke', 4, 6, 40),
(57, 'Sandviç', 5, 6, 65),
(58, 'Limon Suyu', 6, 3, 120),
(59, 'Mango Dondurma', 7, 13, 25),
(60, 'Ciklet', 8, 2, 100),
(61, 'Poğaça', 9, 2, 150),
(62, 'Cam Temizleyici', 10, 7, 50),
(63, 'Kağıt Havlu', 11, 2, 80),
(64, 'Saç Kremi', 12, 6, 60),
(65, 'Bebek Şampuanı', 13, 8, 25),
(66, 'Sünger', 14, 3, 20),
(67, 'Kalemtıraş', 15, 1, 100),
(68, 'Papatya Buketi', 16, 18, 15),
(69, 'Köpek Oyuncağı', 17, 5, 40),
(70, 'Tablet', 18, 600, 10);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `urun_kategori`
--

CREATE TABLE `urun_kategori` (
  `urun_kategori_id` int(11) NOT NULL,
  `urun_kategori` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `urun_kategori`
--

INSERT INTO `urun_kategori` (`urun_kategori_id`, `urun_kategori`) VALUES
(1, 'Meyve,Sebze'),
(2, 'Et,Tavuk,Balık'),
(3, 'Süt, Kahvaltılık'),
(4, 'Temel Gıda'),
(5, 'Meze, Hazır Yemek, Donuk'),
(6, 'İçecek'),
(7, 'Dondurma'),
(8, 'Atıştırmalık'),
(9, 'Fırın, Pastane'),
(10, 'Deterjan, Temizlik'),
(11, 'Kağıt, Islak Mendil'),
(12, 'Kişisel Bakım, Kozmetik, Sağlık'),
(13, 'Bebek'),
(14, 'Ev, Yaşam'),
(15, 'Kitap, Kırtasiye, Oyuncak'),
(16, 'Çiçek'),
(17, 'Pet Shop'),
(18, 'Elektronik');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `calisanlar`
--
ALTER TABLE `calisanlar`
  ADD PRIMARY KEY (`calisan_id`),
  ADD KEY `fk_pozisyon` (`pozisyon_id`);

--
-- Tablo için indeksler `durumlar`
--
ALTER TABLE `durumlar`
  ADD PRIMARY KEY (`durum_id`);

--
-- Tablo için indeksler `indirimler`
--
ALTER TABLE `indirimler`
  ADD PRIMARY KEY (`indirim_id`),
  ADD KEY `fk_urun` (`urun_id`);

--
-- Tablo için indeksler `musteriler`
--
ALTER TABLE `musteriler`
  ADD PRIMARY KEY (`musteri_id`);

--
-- Tablo için indeksler `odeme`
--
ALTER TABLE `odeme`
  ADD PRIMARY KEY (`odeme_id`),
  ADD UNIQUE KEY `siparis_id` (`siparis_id`),
  ADD KEY `fk_odeme_tip` (`odeme_tip_id`);

--
-- Tablo için indeksler `odeme_tip`
--
ALTER TABLE `odeme_tip`
  ADD PRIMARY KEY (`odeme_tip_id`);

--
-- Tablo için indeksler `pozisyonlar`
--
ALTER TABLE `pozisyonlar`
  ADD PRIMARY KEY (`pozisyon_id`);

--
-- Tablo için indeksler `siparisler`
--
ALTER TABLE `siparisler`
  ADD PRIMARY KEY (`siparis_id`),
  ADD KEY `fk_musteri` (`musteri_id`),
  ADD KEY `fk_durum` (`durum_id`);

--
-- Tablo için indeksler `urunler`
--
ALTER TABLE `urunler`
  ADD PRIMARY KEY (`urun_id`),
  ADD KEY `fk_urun_kategori` (`urun_kategori_id`);

--
-- Tablo için indeksler `urun_kategori`
--
ALTER TABLE `urun_kategori`
  ADD PRIMARY KEY (`urun_kategori_id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `calisanlar`
--
ALTER TABLE `calisanlar`
  MODIFY `calisan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- Tablo için AUTO_INCREMENT değeri `durumlar`
--
ALTER TABLE `durumlar`
  MODIFY `durum_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Tablo için AUTO_INCREMENT değeri `indirimler`
--
ALTER TABLE `indirimler`
  MODIFY `indirim_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Tablo için AUTO_INCREMENT değeri `musteriler`
--
ALTER TABLE `musteriler`
  MODIFY `musteri_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Tablo için AUTO_INCREMENT değeri `odeme`
--
ALTER TABLE `odeme`
  MODIFY `odeme_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Tablo için AUTO_INCREMENT değeri `odeme_tip`
--
ALTER TABLE `odeme_tip`
  MODIFY `odeme_tip_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Tablo için AUTO_INCREMENT değeri `pozisyonlar`
--
ALTER TABLE `pozisyonlar`
  MODIFY `pozisyon_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Tablo için AUTO_INCREMENT değeri `siparisler`
--
ALTER TABLE `siparisler`
  MODIFY `siparis_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Tablo için AUTO_INCREMENT değeri `urunler`
--
ALTER TABLE `urunler`
  MODIFY `urun_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- Tablo için AUTO_INCREMENT değeri `urun_kategori`
--
ALTER TABLE `urun_kategori`
  MODIFY `urun_kategori_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `calisanlar`
--
ALTER TABLE `calisanlar`
  ADD CONSTRAINT `fk_pozisyon` FOREIGN KEY (`pozisyon_id`) REFERENCES `pozisyonlar` (`pozisyon_id`);

--
-- Tablo kısıtlamaları `indirimler`
--
ALTER TABLE `indirimler`
  ADD CONSTRAINT `fk_urun` FOREIGN KEY (`urun_id`) REFERENCES `urunler` (`urun_id`);

--
-- Tablo kısıtlamaları `odeme`
--
ALTER TABLE `odeme`
  ADD CONSTRAINT `fk_odeme_tip` FOREIGN KEY (`odeme_tip_id`) REFERENCES `odeme_tip` (`odeme_tip_id`),
  ADD CONSTRAINT `fk_siparis` FOREIGN KEY (`siparis_id`) REFERENCES `siparisler` (`siparis_id`);

--
-- Tablo kısıtlamaları `siparisler`
--
ALTER TABLE `siparisler`
  ADD CONSTRAINT `fk_durum` FOREIGN KEY (`durum_id`) REFERENCES `durumlar` (`durum_id`),
  ADD CONSTRAINT `fk_musteri` FOREIGN KEY (`musteri_id`) REFERENCES `musteriler` (`musteri_id`);

--
-- Tablo kısıtlamaları `urunler`
--
ALTER TABLE `urunler`
  ADD CONSTRAINT `fk_urun_kategori` FOREIGN KEY (`urun_kategori_id`) REFERENCES `urun_kategori` (`urun_kategori_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
