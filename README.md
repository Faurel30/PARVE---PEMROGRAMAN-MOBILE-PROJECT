# PARVE---PEMROGRAMAN-MOBILE-PROJECT
repo untuk project pemrograman mobile

PARVE adalah aplikasi parkir valet berbasis mobile (Flutter). User memesan tiket parkir lewat aplikasi, membayar, lalu mendapat QR code yang di-scan petugas dan diverifikasi admin sebelum mobil diparkirkan.

Desain UI/UX: lihat file [`UI UX PARVE`](UI%20UX%20PARVE) (link Figma).

## Cara menjalankan (setelah clone / pull)

Prasyarat: Flutter SDK (stable) + Android Studio / emulator.

```bash
flutter pub get
flutter run
```

Cek kode & test:

```bash
flutter analyze
flutter test
```

> Catatan Windows: kalau muncul error *Access is denied* / *cannot create file* saat build, kemungkinan diblokir **Controlled Folder Access** Windows Defender. Izinkan `dart.exe`, `dartvm.exe` (folder Flutter SDK) dan `java.exe` (`Android Studio\jbr\bin`) di *Windows Security → Ransomware protection*.

## Struktur folder

```
lib/
  main.dart                    # entry point aplikasi
  screens/
    aktivitas_screen.dart      # halaman Aktivitas: Tiket aktif (QR) & Riwayat parkir
test/
  widget_test.dart
```

Satu halaman = satu file di `lib/screens/`.

## Alur kerja Git

- `main` → versi stabil, jangan push langsung.
- Tiap halaman dikerjakan di branch sendiri, misal `feature/tiket-parkir-digital`.
- Setelah selesai, buat **Pull Request** ke `main`.
