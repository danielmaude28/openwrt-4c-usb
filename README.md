# OpenWrt Xiaomi Mi Router 4C — USB Host + ZeroTier

Repository ini menyimpan konfigurasi dan workflow untuk membangun firmware OpenWrt 25.12.6 bagi Xiaomi Mi Router 4C (ramips/mt76x8).

## Status perangkat

- Firmware hasil build sudah dipasang dan dilaporkan berjalan baik pada router.
- Dukungan host USB sudah diaktifkan pada Device Tree dan paket kernel USB disertakan.
- **Port/konektor USB fisik belum dipasang.** Komponen masih dalam proses pemesanan, sehingga fungsi USB belum dapat dianggap tervalidasi di perangkat nyata.
- ZeroTier dan paket pendukung lain disertakan dalam konfigurasi build.

Build yang berhasil hanya memvalidasi proses kompilasi. Enumerasi perangkat USB, daya port, filesystem, dan stabilitas harus diuji setelah modifikasi hardware selesai.

## Struktur repository

```text
.
├── .github/
│   └── workflows/
│       └── build.yml              # Orkestrasi build GitHub Actions
├── config/
│   └── xiaomi-mi-router-4c.config # Daftar target dan paket firmware
├── docs/
│   └── usb-hardware-validation.md # Catatan hardware dan checklist uji USB
├── scripts/
│   ├── enable-usb-dts.sh          # Mengaktifkan node EHCI/OHCI pada DTS
│   └── validate-config.sh         # Memeriksa target dan paket wajib
└── README.md
```

## Build

1. Buka tab **Actions** pada GitHub.
2. Pilih workflow **Build OpenWrt 25.12.6 Xiaomi 4C (USB aktif + ZeroTier)**.
3. Pilih **Run workflow**.
4. Unduh artifact atau firmware dari GitHub Release setelah workflow selesai.

Workflow menggunakan tag sumber OpenWrt `v25.12.6`. Feed paket saat ini diperbarui saat build, sehingga versi paket feed dapat berubah dari waktu ke waktu.

## Isi konfigurasi utama

- Target: Xiaomi Mi Router 4C, ramips/mt76x8.
- LuCI, SQM/Cake, ttyd, nlbwmon dan utilitas diagnostik.
- USB core, USB 2.0, OHCI, USB storage, ext4 dan FAT.
- TUN dan ZeroTier.

Daftar lengkap dan nilai konfigurasi berada di [config/xiaomi-mi-router-4c.config](config/xiaomi-mi-router-4c.config).

## Catatan keselamatan

- Jangan flash ulang hanya karena repository dirapikan; firmware yang sudah berjalan tidak perlu disentuh.
- Simpan cadangan konfigurasi router dan firmware pemulihan sebelum pengujian hardware.
- Pastikan image yang dipilih memang image sysupgrade untuk Xiaomi Mi Router 4C.
- Jangan menganggap port USB aman memberi daya pada perangkat eksternal tanpa pengukuran dan pengujian yang sesuai.
- Lihat [panduan pengujian USB](docs/usb-hardware-validation.md).
