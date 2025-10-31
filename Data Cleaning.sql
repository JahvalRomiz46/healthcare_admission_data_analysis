SELECT * FROM healthcare.healthcare;

/* DATA CLEANING */

# BUAT BACKUP TABLE
CREATE TABLE `healthcare_backup` (
  `Name` text,
  `Age` int DEFAULT NULL,
  `Gender` text,
  `Blood Type` text,
  `Medical Condition` text,
  `Date of Admission` text,
  `Doctor` text,
  `Hospital` text,
  `Insurance Provider` text,
  `Billing Amount` double DEFAULT NULL,
  `Room Number` int DEFAULT NULL,
  `Admission Type` text,
  `Discharge Date` text,
  `Medication` text,
  `Test Results` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copy isi table utama
INSERT INTO healthcare_backup 
SELECT * FROM healthcare;

SELECT * FROM healthcare;

# UBAH NAMA KOLOM, Mempermudah Analisis
ALTER TABLE healthcare
RENAME COLUMN `Blood Type` TO Blood_Type,
RENAME COLUMN `Medical Condition` TO Medical_Condition,
RENAME COLUMN `Date of Admission` TO Date_of_Admission,
RENAME COLUMN `Insurance Provider` TO Insurance_Provider,
RENAME COLUMN `Billing Amount` TO Billing_Amount,
RENAME COLUMN `Room Number` TO Room_Number,
RENAME COLUMN `Admission Type` TO Admission_Type,
RENAME COLUMN `Discharge Date` TO Discharge_Date,
RENAME COLUMN `Test Results` TO Test_Results;


# INKONSISTENSI KOLOM NAMA
-- Ubah jadi Kapital awal saja
UPDATE healthcare
SET `Name` = CONCAT(UPPER(SUBSTRING(`Name`, 1,1)), LOWER(SUBSTRING(`Name`, 2)));

SELECT * FROM healthcare;

# INKONSISTENSI KOLOM HOSPITAL
-- Cek Spelling Error
SELECT DISTINCT Hospital FROM healthcare ORDER BY Hospital;

-- Standardisasi penamaan di Hospital (LLC, Ltd, Inc, PLC, Group), dihapus menjadi nama utama saja
SELECT
	TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Hospital, 'Inc', ''), 'Ltd', ''), 'LLC', ''),'PLC',''),'Group','')) AS Hospital
	, COUNT(*) AS Counts
FROM healthcare
GROUP BY Hospital
ORDER BY Counts DESC;

UPDATE healthcare
SET Hospital = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Hospital, 'Inc', ''), 'Ltd', ''), 'LLC', ''),'PLC',''),'Group',''));

-- Adapun penulisan and yang dihapus dan menyisakan nama utama hospital gabungan
UPDATE healthcare
SET Hospital = TRIM(REPLACE(REPLACE(Hospital,',', ''),' and', ''));

UPDATE healthcare
SET Hospital = TRIM(REPLACE(Hospital, 'and ', ''));

SELECT DISTINCT Hospital
FROM healthcare
ORDER BY Hospital ASC;

SELECT * FROM healthcare;

# INKONSISTENSI KOLOM INSURANCE PROVIDER
-- Cek spelling
SELECT DISTINCT Insurance_Provider
FROM healthcare;


# CEK SPELLING KOLOM LAIN
SELECT DISTINCT Admission_Type FROM healthcare;
SELECT DISTINCT Medication FROM healthcare;
SELECT DISTINCT Test_Results FROM healthcare;


# CEK DUPLIKASI
SELECT
    Name,
    Date_of_Admission,
    COUNT(*) as Num_Duplicates
FROM
    healthcare
GROUP BY
    Name,
    Date_of_Admission
HAVING
    COUNT(*) > 1 
ORDER BY 1;

-- Cek kebenaran duplikasi
SELECT *
FROM healthcare
WHERE Name = 'Aaron lee'
  AND Date_of_Admission = '2020-07-09';
/* Setelah dicek ternyata banyak baris yang terdapat duplikasi yang persis kecuali di kolom Age, yang mungkin karna entri data ulang untuk perbaikan nilai Age */

-- Cek min & max umur dari baris yang duplikat
SELECT
    Name,
    Medical_Condition,
    Date_of_Admission,
    Billing_Amount,
    COUNT(Age) AS Total_Records,
    MIN(Age) AS Min_Age,
    MAX(Age) AS Max_Age
FROM healthcare
GROUP BY Name, Medical_Condition, Date_of_Admission, Billing_Amount
HAVING COUNT(DISTINCT Age) > 1 AND COUNT(Age) > 1;

-- Mengganti baris duplikat yang berbeda umur dengan menggantinya ke umur tertinggi
UPDATE healthcare AS t1
INNER JOIN (
    SELECT
        Name,
		Medical_Condition,
		Date_of_Admission,
		Billing_Amount,
        MAX(Age) AS Age
    FROM
        healthcare
    GROUP BY
        Name,
		Medical_Condition,
		Date_of_Admission,
		Billing_Amount
    HAVING
        COUNT(DISTINCT Age) > 1
) AS t2 ON
    t1.Name = t2.Name AND
    t1.Medical_Condition = t2.Medical_Condition AND
    t1.Date_of_Admission = t2.Date_of_Admission AND
    t1.Billing_Amount = t2.Billing_Amount
SET
    t1.Age = t2.Age; 

# HAPUS SEMUA BARIS DUPLIKAT
-- Buat table baru sementara
CREATE TABLE healthcare_cleaned AS
SELECT DISTINCT * FROM healthcare;
-- Drop Table lama
DROP TABLE healthcare;
-- Ganti table cleaned ke nama asli
ALTER TABLE healthcare_cleaned 
RENAME TO healthcare;


# CEK TIPE DATA
DESCRIBE healthcare;

# UBAH TIPE DATA Date of Admission & Discharge Date
ALTER TABLE healthcare
MODIFY COLUMN Date_of_Admission DATE;
ALTER TABLE healthcare
MODIFY COLUMN Discharge_Date DATE;

# UBAH TIPE DATA Billing Amount ke Decimal dengan batas 2 angka di belakang koma
ALTER TABLE healthcare
MODIFY COLUMN Billing_Amount DECIMAL(10, 2);

# BUAT KOLOM BARU `Length of Stay` untuk menunjukkan lama inap pasien
ALTER TABLE healthcare
ADD COLUMN Length_of_Stay INT;

-- Isi kolom dengan hasil dari rentang tanggal keluar - tanggal masuk
UPDATE healthcare SET Length_of_Stay = DATEDIFF(Discharge_Date, Date_of_Admission);

/* SELESAI */
SELECT * FROM healthcare;