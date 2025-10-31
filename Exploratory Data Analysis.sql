SELECT * FROM healthcare;


/* Exploratory Data Analysis (EDA) */
SELECT Gender, COUNT(Gender)
FROM healthcare
GROUP BY Gender;

# KOLOM BARU Age_Category
ALTER TABLE healthcare
ADD COLUMN Age_Category VARCHAR(24);

-- Isi nilai Age_Category
UPDATE healthcare
SET Age_Category =
	CASE
		WHEN Age BETWEEN 18 AND 35 THEN 'Adult'
        WHEN Age BETWEEN 36 AND 55 THEN 'Middle Age'
        WHEN Age BETWEEN 56 AND 84 THEN 'Old'
        ELSE 'Senior'
    END;

# Mayoritas Pasien berdasarkan Kategori Umur
SELECT Age_Category, COUNT(Age_Category) AS Total_Patient
FROM healthcare
GROUP BY Age_Category
ORDER BY 2 DESC;

# Cek Rata-rata tagihan berdasarkan kategori umur
SELECT Age_Category, AVG(Length_of_Stay) AS Avg_Length_of_Stay
FROM healthcare
GROUP BY Age_Category
ORDER BY 2 DESC;


# Menghitung korelasi linear antar lama inap dengan jumlah tagihan
SELECT Length_of_Stay, AVG(Billing_Amount) AS Avg_Billing
FROM healthcare
GROUP BY Length_of_Stay
ORDER BY Length_of_Stay ASC;
/* Tidak ada hubungan linear, mungkin juga karena nilai Avg_Billing di dataset ini didapat dengan Random Function */

# Hubungan Jenis Penerimaan Pasien dengan Lama Inap
SELECT Admission_Type, AVG(Length_of_Stay) AS Avg_Length_of_Stay
FROM healthcare
GROUP BY Admission_Type
ORDER BY Avg_Length_of_Stay DESC;

# Rata-rata lama inap paling lama berdasarkan Jenis Penerimaan pasien
SELECT Admission_Type, AVG(Length_of_Stay) AS Avg_Length_of_Stay
FROM healthcare
GROUP BY Admission_Type
ORDER BY Avg_Length_of_Stay DESC;


# Buat Kolom Baru Length of Stay Category by Range
-- Cek Range Waktu Inap
SELECT MIN(Length_of_Stay), MAX(Length_of_Stay)
FROM healthcare;
-- Add Column Baru
ALTER TABLE healthcare
ADD COLUMN Stay_Range VARCHAR(10);
-- Isi kolom baru dengan kategori tiap range
UPDATE healthcare
SET Stay_Range =
    CASE
		WHEN Length_of_Stay BETWEEN 0 AND 7 THEN '0-7 Days'
        WHEN Length_of_Stay BETWEEN 8 AND 15 THEN '8-15 Days'
        ELSE '16-30 Days'
    END;

# Mayoritas Lama Inap Pasien
SELECT Stay_Range, COUNT(Stay_Range) AS Total_Patient
FROM healthcare
GROUP BY Stay_Range
ORDER BY 2 DESC;




# Evaluasi Efektivitas Pengobatan
SELECT Medical_Condition, Medication, Test_Results, COUNT(Medication) AS Cnt
FROM healthcare
GROUP BY Medical_Condition, Medication, Test_Results
ORDER BY 1, 2, 4 DESC;
-- BELOM SELESAI --

# Mayoritas Kondisi Sakit para Pasien berdasarkan Kategori Umur
SELECT Age_Category, Medical_Condition, COUNT(Medical_Condition) AS Total_Patient
FROM healthcare
GROUP BY Age_Category, Medical_Condition
ORDER BY 3 DESC;

# Pasien yang paling sering berkunjung
SELECT Name, Medical_Condition, COUNT(Name) AS Visit_Amount
FROM healthcare
GROUP BY Name, Medical_Condition
ORDER BY 3 DESC;

# Provider Asuransi dengan Rata-rata tagihan pasien paling tinggi
SELECT Insurance_Provider, AVG(Billing_Amount) AS Avg_Bill
FROM healthcare
GROUP BY Insurance_Provider
ORDER BY 2 DESC;

# Mayoritas Golongan Darah Pasien
SELECT Blood_Type, COUNT(Blood_Type) AS Total
FROM healthcare
GROUP BY Blood_Type
ORDER BY 2 DESC;



SELECT * FROM healthcare;