# CaliSplit - Aplikasi Tracker Kalistenik (UTS Pemrograman Mobile)

Aplikasi mobile untuk mencatat rutinitas latihan kalistenik dan mengeksplorasi katalog gerakan kalistenik yang terintegrasi dengan REST API dan backend database.

## Identitas Pembuat
* **Nama:** Febrian
* **NIM:** 2415051009
* **Kelas:** (Isi kelasmu di sini)
* **Program Studi:** Pendidikan Teknik Informatika
* **Universitas:** Universitas Pendidikan Ganesha (UNDIKSHA)

## Fitur Utama
1. **Dashboard (Home):** Menampilkan ringkasan total rutinitas yang telah disimpan.
2. **Katalog Gerakan (Explore):** Menampilkan daftar gerakan kalistenik (diambil dari Wger REST API).
3. **Detail Gerakan:** Menampilkan deskripsi lengkap dari sebuah gerakan.
4. **My Routine (Create/Add):** Form untuk menambah rutinitas latihan baru dengan validasi input.
5. **Edit & Delete (Update & Delete):** Mengubah atau menghapus data rutinitas latihan yang sudah tersimpan.
6. **Profil Pembuat:** Menampilkan biodata developer aplikasi.

## Tech Stack
* **Framework:** Flutter (Dart)
* **State Management:** Provider (ChangeNotifier)
* **Architecture:** MVC Pattern (Model-View-Controller)
* **REST API:** Wger API (Public Fitness API)
* **Backend & Database:** Supabase (PostgreSQL)

## Cara Menjalankan Project
1. Pastikan Flutter SDK sudah terpasang.
2. Clone repository ini: `git clone https://github.com/gedefebry236-hub/uts_2415051009_febrian.git`
3. Jalankan `flutter pub get` untuk mengunduh semua *dependencies*.
4. Jalankan aplikasi dengan `flutter run` pada emulator atau perangkat fisik.