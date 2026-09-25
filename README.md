# Memory Match Card - Neo-Brutalism

Aplikasi mobile game Memory Match Card berbasis Flutter yang dibuat untuk kegiatan Flutter Speed Code Challenge. Aplikasi ini menerapkan gaya desain Neo-Brutalism dengan mekanisme permainan mencocokkan pasangan kartu tertutup melalui 5 tingkat kesulitan.

---

## Karakteristik Desain (Neo-Brutalism)

Aplikasi dibangun dengan prinsip desain Neo-Brutalism yang konsisten pada seluruh komponen:
- Border hitam tegas berukuran 3 hingga 3.5 px di semua kartu, tombol, container, dan badge.
- Hard shadow tanpa blur (`blurRadius: 0`) dengan offset `(4, 4)` untuk memberikan efek kedalaman datar yang kuat.
- Palet warna kontras tinggi, menggunakan perpaduan Warm Cream sebagai warna dasar dengan warna aksen seperti Electric Yellow, Hot Pink, Cyan, Lime Green, dan Oranye.
- Sudut komponen sedikit melengkung (radius 8-14 px) untuk menjaga kesan geometris yang rapi.
- Tipografi Space Grotesk dengan ketebalan bold pada teks judul dan tombol.
- Efek interaksi tombol taktil yang bergeser ke bawah saat ditekan (press-down effect).

---

## Fitur Aplikasi

1. **Splash Screen**: Layar pembuka beranimasi dengan maskot kartu ganda, elemen ornamen retro, dan progress bar pemuatan sebelum masuk ke menu utama.
2. **Kartu Tertutup**: Semua kartu tertutup di awal permainan dengan motif tanda tanya dan warna khas Neo-Brutalism.
3. **Animasi Buka Kartu (3D Flip)**: Kartu berputar secara 3D pada sumbu horizontal saat dipilih oleh pemain dengan rendering yang stabil.
4. **Pencocokan Pasangan Kartu**: Logika memeriksa kesamaan identitas kartu. Jika cocok, kartu terkunci terbuka; jika tidak cocok, kartu otomatis tertutup kembali setelah jeda singkat.
5. **Penghitung Percobaan (Moves) & Timer**: Menghitung jumlah langkah dan waktu bermain secara waktu nyata.
6. **Progress Bar & Indikator Bintang Dinamis**: Progress bar di bawah arena bermain menyusut setiap kali pemain melangkah. Ketiga bintang diposisikan sesuai ambang batas (threshold) langkah dan otomatis meredup saat bar menyusut melewati posisinya.
7. **Batas Langkah & Game Over**: Setiap level memiliki batas langkah maksimal. Jika bar habis sebelum semua kartu cocok, dialog Game Over muncul dengan opsi mencoba ulang level atau kembali ke menu.
8. **5 Level Permainan**:
   - Level 1: Grid 2x2 (4 kartu / 2 pasang) - Tema Buah
   - Level 2: Grid 3x2 (6 kartu / 3 pasang) - Tema Hewan
   - Level 3: Grid 4x2 (8 kartu / 4 pasang) - Tema Transportasi
   - Level 4: Grid 4x3 (12 kartu / 6 pasang) - Tema Hobi & Olahraga
   - Level 5: Grid 4x4 (16 kartu / 8 pasang) - Tema Elemen & Alam
9. **Sistem Skor & Unlock Level**:
   - Pemain memperoleh 1 hingga 3 bintang sesuai efisiensi langkah.
   - Menyelesaikan suatu level otomatis membuka level berikutnya.
   - Rekor langkah tersedikit dan waktu terbaik disimpan secara lokal.
10. **Dialog Hasil (Victory & Game Over)**: Menampilkan statistik performa dan navigasi cepat antar level.

---

## Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    GAME_LEVEL ||--o{ GAME_CARD : "menghasilkan"
    GAME_LEVEL ||--o{ GAME_SESSION : "dimainkan pada"
    GAME_LEVEL ||--|| PLAYER_PROGRESS : "memiliki riwayat"
    GAME_SESSION ||--|{ GAME_CARD : "mengontrol status"

    GAME_LEVEL {
        int level_number PK "Nomor Level 1-5"
        string level_name "Nama Level"
        int grid_rows "Jumlah baris"
        int grid_cols "Jumlah kolom"
        int total_pairs "Jumlah pasang kartu"
        int target_moves "Target efisiensi 3 bintang"
        int max_moves "Batas maksimal langkah sebelum kalah"
    }

    GAME_CARD {
        string card_id PK "ID unik kartu"
        int pair_id FK "ID identitas pasangan"
        string emoji "Konten kartu"
        string title "Nama item"
        boolean is_face_up "Status terbuka"
        boolean is_matched "Status cocok"
    }

    GAME_SESSION {
        string session_id PK "ID sesi aktif"
        int level_number FK "Level yang dimainkan"
        int moves_count "Jumlah percobaan"
        int matches_found "Jumlah pasangan cocok"
        int elapsed_seconds "Waktu bermain"
        int stars_earned "Perolehan bintang"
        boolean is_completed "Status selesai"
        boolean is_game_over "Status kehabisan langkah"
    }

    PLAYER_PROGRESS {
        int level_number PK, FK "Nomor level"
        boolean is_unlocked "Status level terbuka"
        int best_moves "Percobaan tersedikit"
        int best_time_seconds "Waktu tercepat"
        int stars_earned "Bintang tertinggi"
    }
```

---

## Struktur Direktori

```
lib/
├── main.dart                      # Entry point, orientasi layar, dan inisialisasi aplikasi
├── theme/
│   └── neo_brutalism_theme.dart   # Desain sistem: warna, border, bayangan, dan tipografi
├── models/
│   ├── game_card.dart             # Model objek kartu permainan
│   ├── game_level.dart            # Konfigurasi data dan ambang langkah 5 level
│   └── player_progress.dart       # Model rekor dan progres pemain
├── services/
│   └── game_storage.dart          # Pengelolaan state progres dan penyimpanan lokal
├── widgets/
│   ├── neo_card.dart              # Komponen kartu dengan animasi flip 3D
│   ├── neo_button.dart            # Komponen tombol bergaya taktil
│   ├── neo_badge.dart             # Komponen indikator statistik (Moves, Matched, Time)
│   ├── victory_dialog.dart        # Dialog kemenangan saat level selesai
│   └── game_over_dialog.dart      # Dialog saat langkah pemain habis
└── screens/
    ├── splash_screen.dart         # Layar pembuka beranimasi interaktif
    ├── home_screen.dart           # Halaman menu utama dan pemilihan level
    └── game_screen.dart           # Arena permainan kartu dan kontrol bar
```


---

## Cara Menjalankan Aplikasi

1. Clone repositori ini:
   ```bash
   git clone https://github.com/SukaMCD/MEMORY-CARD-GAME.git
   ```

2. Unduh paket dependensi:
   ```bash
   flutter pub get
   ```

3. Jalankan aplikasi:
   - Untuk Web / Browser:
     ```bash
     flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
     ```
     Lalu buka `http://localhost:8080` pada browser.
   - Untuk Emulator Android / Perangkat Fisik:
     ```bash
     flutter run
     ```

4. Menjalankan pengujian (Unit/Widget Test):
   ```bash
   flutter test
   ```
