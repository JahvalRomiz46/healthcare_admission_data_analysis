# Analisis Data Healthcare 🏥

## Deskripsi Proyek
Proyek ini adalah studi kasus analisis data mulai dari Data Cleaning pada data mentah, melakukan Feature Engineering, hingga menjalankan Exploratory Data Analysis (EDA).

Dikarenakan dataset healthcare yang digunakan memiliki nilai metrik (seperti `Billing Amount`) yang didapat dari hasil fungsi random yang tidak realistis. Hasilnya nilai tersebut tidak bisa dijadikan insight karena rata2 nilainya tidak memiliki perbedaan yang signifikan. Oleh karena itu, fokus utama dari proyek ini bukan untuk menghasilkan insight bisnis yang prediktif, melainkan untuk menunjukkan proses kritis dalam mengidentifikasi, membersihkan, dan menata data yang kotor serta beradaptasi dengan keterbatasan data yang ditemukan selama proses analisis.

Tools yang digunakan: MySQL

---

## Dataset
Dataset yang digunakan merupakan dataset [healthcare](https://www.kaggle.com/datasets/prasad22/healthcare-dataset) catatan penerimaan pasien yang didapat dari Kaggle. Dataset ini memiliki kolom sebagai berikut:
1. Name
2. Age
3. Gender
4. Blood Type
5. Medical Condition
6. Date of Admission
7. Doctor
8. Hospital
9. Insurance Provider
10. Billing Amount
11. Room Number
12. Admission Type
13. Discharge Date
14. Medication
15. Test Results

---

## Alur Kerja Proyek
Proyek ini dibagi menjadi dua tahap utama:
- Tahap 1: Data Cleaning & Normalisasi
- Tahap 2: Feature Engineering & Exploratory Data Analysis (EDA)

### Tahap 1: Data Cleaning
Dataset awal memiliki 55.500 baris data pasien yang mengandung berbagai masalah integritas data.
#### 1.1. Mengganti Format Penamaan Kolom & Tipe Data
- Mengubah semua nama kolom yang mengandung spasi seperti `Insurance Provider` menjadi ke format snake_case seperti `Insurance_Provider` untuk mempermudah penulisan query.
- Mengubah tipe data kolom `Date_of_Admission` & `Discharge_Date` dari VARCHAR ke DATE, mengubah `Billing_Amount` dari FLOAT ke DECIMAL(10, 2) agar mempermudah analisis.

#### 1.2. Perbaikan Inkonsistensi
Di proses ini dilakukan perbaikan inkonsistensi penulisan yang terdapat pada kolom `Name`, `Hospital`, `Insurance_Provider`, seperti:
- Mengubah besar kecil penulisan kolom `Name` ke kombinasi Upper & Lower agar menghasilkan huruf kapital di awal
- Menghapus penamaan struktur kepemilikan perusahaan di kolom Hospital (seperti Inc, Ltd, LLC, PLC, Group di belakang nama perusahaan) agar memudahkan analisis.
- Menghapus tanda baca koma, kata "dan" yang menggantung, dan trim spasi di kolom Hospital agar konsisten.

#### 1.3. Mengatasi Duplikasi
Ditemukan banyak baris data pasien yang persis duplikat di semua kolom kecuali di kolom `Age`, kemungkinan duplikatnya merupakan salah satu contoh kesalahan entri karena update umur pasien.

Tindakan yang dilakukan yaitu mengganti nilai 1 duplikatnya yang memiliki umur lebih rendah dengan umur yang lebih tinggi. Dengan begitu pasien yang duplikat memiliki nilai yang sama di semua kolom. Setelah itu baru bisa dilakukan penghapusan baris yang duplikat.

### Tahap 2: Feature Engineering & Exploratory Data Analysis (EDA)
#### 2.1 Membuat kolom baru
- Membuat kolom `Length_of_Stay` untuk mengetahui lama inap pasien dengan menghitung jarak waktu `Date_of_Admission` dan `Discharge_Date` dengan DATEIFF.
- Membuat kolom `Age_Category` yang membagi pasien ke dalam kelompok umur 'Adult', 'Middle Age', 'Old', dan 'Senior' untuk analisis demografis.
- Membuat kolom `Stay_Range` yang mengelompokkan `Length_of_Stay` ke dalam kategori '0-7 Days', '8-15 Days', '16-30 Days' untuk melihat distribusi lama inap.

#### 2.2 EDA
Seperti yang sudah dikatakan di awal bahwa, dikarenakan dataset yang digunakan memiliki nilai metrik seprti nilai kolom `Billing_Amount` yang random, maka saya tidak dapat melakukan analisis dengan tepat karena tidak adanya perbedaan signifikan antara nilai `Billing_Amount` di setiap penggunaan untuk analisis. Maka dari itu, yang bisa saya lakukan hanyalah analisis eksplorasi lain yang terdapat di dataset, hasilnya adalah sebagai berikut:

- Mayoritas kategori umum berdasarkan dataset ini yaitu kategori Old yang berjumlah 21443 pasien, disusul dengan kategori Middle Age yang berjumlah 14789 pasien.
- Pasien umur di atas 84 / Senior merupakan kategori umur pasien dengan lama inap paling lama dibanding kategori lainnya.
- Menguatkan statement sebelumnya di mana Billing Amount didapat dari hasil random, analisis korelasi linear antara lama inap dengan jumlah tagihan ditemukan bahwa lama inap 1 hari dengan 30 hari memiliki rata-rata biaya tagihan yang hampir mirip (25271 : 25430) yang mana tidak masuk akal dan tidak bisa diambil kesimpulan/insight.
- Mayoritas lama inap berada di rentang 16-30 hari yang memiliki total pasien sebanyak 24952 pasien.
- Mayoritas medical condition/kondisi sakit para pasien terdapat pada kategori umur Old dengan sakit Diabetes yang memimpin dengan jumlah pasien terbanyak.
- Blue Cross merupakan perusahaan asuransi dengan rata-rata Billing Amount / jumlah tagihan tertinggi dibanding perusahaan asuransi lain (meskipun rata-ratanya tidak berbeda jauh dikarenakan hasil nilai random).
- Golongan darah AB+ merupakan golongan darah pasien dengan jumlah kunjungan terbanyak.

---

## Conclusion
Dari mengerjakan proyek ini, saya belajar banyak untuk mengatasi tantangan pembersihan data yang cukup rumit dan scope baru (bidang kesehatan) yang belum pernah saya lakukan sebelumnya. Tidak hanya itu, dengan dataset yang mengandung kolom hasil randomisasi seperti kolom `Billing_Amount` / total tagihan, menjadikan analisis akan proyek ini terbatas. Dikarenakan saya merasa tidak bisa mendapat insight dari analisis total tagihan, saya hanya melakukan analisis eksplorasi dari kolom lain yang walaupun tidak bisa menghasilkan key insight akan performa layanan kesehatan/healthcare yang lebih bermakna.
