# OpenWrt Xiaomi Mi Router 4C — USB Storage, ZeroTier, DDNS & Adblock

Repository ini membangun OpenWrt 25.12.6 untuk Xiaomi Mi Router 4C (ramips/mt76x8). Seluruh fitur firmware sebelumnya dipertahankan; penambahan saat ini adalah dukungan exFAT, Dynamic DNS, dan Adblock DNS.

## Status perangkat dan batas validasi

- Firmware hasil build sebelumnya sudah dipasang dan dilaporkan berjalan baik.
- Port/konektor USB fisik **belum dipasang**. Karena itu, controller, suplai 5 V, enumerasi perangkat, serta baca/tulis storage belum tervalidasi pada hardware nyata.
- Build CI yang sukses hanya membuktikan image berhasil dibuat dan lolos pemeriksaan otomatis; bukan bukti port USB fisik sudah berfungsi.
- Tidak ada workflow PR yang melakukan flashing. Build PR hanya menghasilkan artifact untuk ditinjau.
- Release `latest` hanya boleh diperbarui oleh push ke `main` setelah seluruh langkah build dan validasi berhasil.

## Peta repository

| Path | Tanggung jawab |
|---|---|
| `.github/workflows/build.yml` | Build OpenWrt, validasi patch dan image, membuat manifest/checksum, mengunggah artifact. Hanya push `main` yang menerbitkan Release `latest`. |
| `.github/workflows/validate.yml` | Pemeriksaan sintaks shell, regresi patch DTS dengan fixture, dan pilihan paket. |
| `config/xiaomi-mi-router-4c.config` | Target perangkat dan daftar seluruh paket wajib. |
| `scripts/enable-usb-dts.sh` | Mengaktifkan EHCI/OHCI dan gagal bila status keduanya tidak dapat diverifikasi. |
| `scripts/validate-config.sh` | Menghentikan build bila target atau salah satu paket wajib hilang setelah `defconfig`. |
| `tests/test-usb-dts.sh` | Menguji patch DTS pada fixture tanpa hardware. |
| `docs/usb-hardware-validation.md` | Checklist pemasangan dan pengujian port USB fisik. |
| `docs/CHANGELOG.md` | Riwayat perubahan, dampak, dan status validasi. |
| `assets/README.md` | Panduan aset dokumentasi. |

## Fitur firmware

| Kelompok | Paket utama | Keterangan |
|---|---|---|
| Administrasi | `luci`, `luci-app-ttyd` | Web UI dan terminal web. |
| QoS | `luci-app-sqm`, `sqm-scripts`, `kmod-sched-cake` | SQM/Cake dipertahankan. |
| Monitoring | `luci-app-nlbwmon`, `iftop`, `conntrack`, `htop` | Pemantauan trafik dan koneksi dipertahankan. |
| USB host | `kmod-usb-core`, `kmod-usb2`, `kmod-usb-ohci`, `kmod-usb-storage`, `kmod-usb-storage-uas`, `usbutils` | Dukungan controller dan storage USB. |
| Filesystem | `kmod-fs-ext4`, `kmod-fs-vfat`, `kmod-fs-exfat`, `exfat-fsck`, `exfat-mkfs` | ext4, FAT/VFAT, dan exFAT. |
| VPN/overlay | `kmod-tun`, `zerotier` | Dipertahankan. |
| Dynamic DNS | `ddns-scripts`, `ddns-scripts-services`, `luci-app-ddns` | UI disertakan; pengguna tetap harus memilih provider dan mengisi kredensial. |
| Adblock DNS | `adblock`, `luci-app-adblock` | Paket disertakan, tetapi service tidak diaktifkan/dikonfigurasi otomatis. |

## Catatan kapasitas dan penggunaan

Mi Router 4C memiliki flash 16 MB dan RAM 64 MB. Ruang flash harus diperiksa pada image akhir, sedangkan Adblock dapat menghabiskan RAM saat memproses daftar domain.

- Adblock disertakan agar tersedia di LuCI, tetapi jangan mengaktifkannya sebelum pengujian. Mulai dengan daftar blokir kecil dan pantau RAM/log sistem.
- Jika router mengalami OOM, DNS lambat, atau layanan lain terganggu, nonaktifkan Adblock; jangan memperbesar daftar.
- Dynamic DNS tidak aktif secara fungsional sebelum provider, hostname, dan kredensial dikonfigurasi.
- exFAT tersedia melalui paket kernel dan utilitas. Uji baca/tulis dan unmount aman setelah port USB fisik dipasang.
- Tidak ada Samba/file server atau paket berat lain yang ditambahkan.

## Cara kerja build dan bukti hasil

1. GitHub Actions mengambil OpenWrt pada tag `v25.12.6`.
2. Feeds diperbarui; commit SHA setiap feed dicatat dalam `feeds-lock.txt` agar isi sumber yang dipakai setiap build dapat diaudit. Feed belum dikunci ke SHA tetap lintas-build.
3. Skrip mengaktifkan EHCI/OHCI. Build gagal jika node DTS tidak ditemukan, duplikat, atau status aktif tidak dapat diverifikasi.
4. Konfigurasi disalin, `make defconfig` dijalankan, lalu semua paket wajib diperiksa.
5. Firmware dikompilasi. Hasil harus berisi tepat satu image sysupgrade Xiaomi 4C dan ukurannya harus di bawah batas konservatif 15 MiB.
6. Artifact menyertakan image, konfigurasi final, daftar paket, patch USB, revisi feed, manifest, dan checksum SHA256.
7. Build PR dan build manual hanya menghasilkan artifact. Release `latest` tidak diperbarui oleh build PR.

Buka **Actions → Build OpenWrt 25.12.6 Xiaomi 4C** untuk melihat proses. Jika build gagal, periksa step pertama yang gagal dan log lengkapnya. Build penuh dapat memerlukan waktu cukup lama.

## Keselamatan

- Jangan flash router yang sedang digunakan hanya karena repository atau dokumentasi berubah.
- Jangan menganggap build sukses sebagai validasi USB fisik.
- Pastikan pinout, D+/D-, 5 V, GND, proteksi, dan batas arus diperiksa sebelum memasang konektor.
- Jangan mengaktifkan automount sebelum pengujian manual USB lulus.
- Jangan memasukkan kredensial DDNS ke repository, konfigurasi publik, atau log CI.
- Jangan merge PR atau memasang firmware tanpa persetujuan eksplisit pemilik perangkat.
