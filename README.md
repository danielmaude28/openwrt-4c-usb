# OpenWrt Xiaomi Mi Router 4C — USB Host + ZeroTier

Repository ini berisi konfigurasi, skrip, dokumentasi, dan workflow untuk membangun OpenWrt 25.12.6 bagi Xiaomi Mi Router 4C (ramips/mt76x8).

## Status perangkat dan batas validasi

- Firmware hasil build sebelumnya sudah dipasang dan dilaporkan berjalan baik pada router.
- Konfigurasi build menyertakan dukungan host USB (EHCI/OHCI), USB storage, filesystem ext4/FAT, dan utilitas USB.
- **Port/konektor USB fisik belum dipasang.** Komponen masih menunggu diterima/dipasang. Karena itu, fungsi USB pada perangkat nyata belum tervalidasi.
- ZeroTier dan paket pendukung jaringan disertakan dalam konfigurasi.

Build yang sukses membuktikan proses kompilasi selesai; itu **bukan** bukti port USB fisik, suplai 5 V, enumerasi perangkat, atau stabilitas sudah lulus uji.

## Peta repository

| Path | Tanggung jawab | Dampak |
|---|---|---|
| `.github/workflows/build.yml` | Mengambil sumber OpenWrt, memasang dependensi, menjalankan skrip, membangun image, mengunggah artifact, dan memperbarui Release `latest` dari `main`. | Mengatur proses build dan publikasi; tidak mengubah router yang sudah berjalan. |
| `.github/workflows/validate.yml` | Memeriksa sintaks skrip dan keberadaan opsi konfigurasi penting pada PR/push yang ditentukan. | Pemeriksaan cepat repository, bukan build firmware penuh. |
| `config/xiaomi-mi-router-4c.config` | Daftar target perangkat dan paket yang dipilih. | Menentukan komponen yang masuk image firmware. |
| `scripts/enable-usb-dts.sh` | Mengubah node `ehci` dan `ohci` pada Device Tree menjadi `status = "okay"`, atau menambahkan blok bila belum ada. | Mengubah konfigurasi hardware USB saat proses build; tidak memasang port fisik. |
| `scripts/validate-config.sh` | Memastikan target Xiaomi 4C dan paket wajib aktif setelah `make defconfig`; memberi peringatan untuk paket opsional yang tidak aktif. | Menghentikan build bila persyaratan wajib tidak terpenuhi. |
| `docs/usb-hardware-validation.md` | Prosedur dan kriteria pengujian setelah port USB dipasang. | Panduan validasi fisik; belum berarti pengujian telah dilakukan. |
| `docs/CHANGELOG.md` | Catatan perubahan repository per versi/PR. | Riwayat perubahan dan alasan perubahan. |

## Cara kerja build

1. GitHub Actions checkout commit yang memicu workflow.
2. Mengambil OpenWrt pada tag sumber `v25.12.6`.
3. Memperbarui dan memasang feeds paket.
4. Menjalankan `scripts/enable-usb-dts.sh` untuk mengaktifkan node EHCI/OHCI di DTS Xiaomi 4C.
5. Menyalin konfigurasi dari `config/xiaomi-mi-router-4c.config`, lalu menjalankan `make defconfig`.
6. Memvalidasi target dan paket wajib dengan `scripts/validate-config.sh`.
7. Mengunduh sumber paket dan mengompilasi firmware.
8. Mengunggah folder hasil sebagai artifact bernomor berdasarkan run.
9. **Hanya build dari branch `main`** yang membuat atau memperbarui GitHub Release bertag `latest`. Build manual dari branch pengembangan hanya menghasilkan artifact; tidak mengganti Release `latest`.

Feed paket diperbarui saat build. Walaupun tag inti OpenWrt dikunci pada `v25.12.6`, versi paket feed dapat berubah antar-build. Untuk reproduksibilitas yang lebih kuat, feed nantinya perlu dikunci ke commit tertentu.

## Isi konfigurasi firmware

| Kelompok | Paket/opsi | Kegunaan |
|---|---|---|
| Target | `ramips/mt76x8`, Xiaomi Mi Router 4C | Memastikan image untuk perangkat yang benar. |
| Web admin | `luci` | Antarmuka administrasi web. |
| QoS | `luci-app-sqm`, `sqm-scripts`, `kmod-sched-cake` | Pengelolaan antrean dan latensi jaringan. |
| Monitoring/utilitas | `ttyd`, `nlbwmon`, `iftop`, `conntrack`, `htop`, `nano`, `curl` | Terminal web, pemantauan trafik, koneksi, dan administrasi. |
| USB | `kmod-usb-core`, `kmod-usb2`, `kmod-usb-ohci`, `kmod-usb-storage`, `usbutils`, `block-mount` | Infrastruktur host USB dan pengelolaan storage. |
| Filesystem | `kmod-fs-ext4`, `kmod-fs-vfat`, `blkid` | Dukungan filesystem ext4 dan FAT serta identifikasi block device. |
| VPN/overlay | `kmod-tun`, `zerotier` | Interface TUN dan ZeroTier. |

Daftar opsi lengkap berada di [config/xiaomi-mi-router-4c.config](config/xiaomi-mi-router-4c.config). Paket yang tercantum belum tentu otomatis dikonfigurasi atau dijalankan; layanan tetap perlu pengaturan sesuai kebutuhan.

## Cara menjalankan dan membaca hasil

- Untuk pemeriksaan cepat, buka **Actions → Validate repository structure**.
- Untuk build pengujian branch, jalankan **Actions → Build OpenWrt 25.12.6 Xiaomi 4C (USB aktif + ZeroTier) → Run workflow**.
- Periksa log setiap step bila gagal. Artifact build tersedia pada halaman run.
- Setelah perubahan masuk ke `main`, workflow build otomatis berjalan. Release `latest` baru diperbarui **setelah build berhasil**.
- Sebelum memakai image, cocokkan nama target perangkat, baca catatan release, dan verifikasi checksum.

## Keselamatan dan hal yang belum dijanjikan

- Jangan flash ulang hanya karena struktur repository atau dokumentasi berubah. Firmware yang sudah berjalan tidak perlu disentuh.
- Simpan backup konfigurasi dan siapkan metode recovery sebelum eksperimen firmware.
- Pastikan image benar-benar untuk Xiaomi Mi Router 4C; salah image dapat membuat perangkat tidak bisa boot.
- Jangan menghubungkan perangkat USB sebelum pinout, polaritas, jalur data, dan suplai daya diverifikasi. Jangan menganggap port aman memasok arus tanpa pengukuran.
- Jangan menyatakan USB siap produksi sampai checklist di [panduan pengujian USB](usb-hardware-validation.md) lulus.
- Validasi repository tidak menguji kualitas solder, rangkaian daya, suhu, atau fungsi USB pada hardware.
