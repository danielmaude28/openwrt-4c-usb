# Riwayat perubahan

Dokumen ini mencatat perubahan repository, alasan, dampak, dan status validasi. Perubahan pada branch PR belum berlaku pada firmware di router atau branch `main` sebelum PR digabung dan firmware baru dipasang secara terpisah.

## 2026-11-16 — Penambahan USB WAN (Ethernet/modem), exFAT, Dynamic DNS, Adblock, dan penguatan build (PR #1, branch `chore/restructure-build`)

Status: **diusulkan pada PR; build penuh sedang/akan diuji melalui GitHub Actions. Belum dianggap lulus sebelum run selesai sukses.**

### Perubahan konfigurasi firmware
- Menambahkan `kmod-usb-storage-uas` untuk perangkat storage yang mendukung UAS.
- Mempertahankan seluruh paket sebelumnya: LuCI, SQM/Cake, ttyd, nlbwmon, iftop, conntrack, htop, nano, curl, USB host/storage, ext4/VFAT, TUN, dan ZeroTier.
- Menambahkan dukungan WAN USB Ethernet: CDC Ethernet, RNDIS, CDC-NCM, ASIX, dan Realtek RTL8152.
- Menambahkan dukungan modem USB QMI, MBIM, NCM, dan modem serial/PPP melalui driver, utility, dan protokol LuCI.
- Menambahkan `kmod-fs-exfat`, `exfat-fsck`, dan `exfat-mkfs` untuk filesystem exFAT.
- Menambahkan `ddns-scripts`, `ddns-scripts-services`, dan `luci-app-ddns`.
- Menambahkan `adblock` dan `luci-app-adblock`. Paket disertakan, tetapi service tidak diaktifkan/dikonfigurasi otomatis.

### Penguatan proses build
- Memicu build artifact saat PR ke `main`; build PR tidak mempublikasikan Release `latest`.
- Mengubah pemeriksaan konfigurasi agar seluruh paket lama dan paket baru wajib aktif setelah `make defconfig`. Paket yang hilang akan menghentikan build.
- Memperketat skrip DTS: EHCI/OHCI harus terbukti berstatus `okay`; kondisi tidak sesuai menghentikan build.
- Menambahkan tes regresi DTS dengan fixture untuk status disabled, status yang belum ditentukan, dan DTS yang hilang.
- Mewajibkan tepat satu image sysupgrade untuk target Xiaomi 4C dan batas ukuran konservatif 15 MiB.
- Artifact menyertakan config final, daftar paket, patch DTS, SHA revisi feed, manifest build, dan checksum.
- SHA feed dicatat per build; ini membantu audit, tetapi belum mengunci feed pada SHA tetap lintas-build.

### Dampak dan risiko
- Image bertambah karena dukungan exFAT, DDNS, dan Adblock serta dependensinya. Ukuran final harus dilihat pada artifact hasil build, bukan diperkirakan dari nama paket.
- Adblock dapat membebani RAM 64 MB ketika memproses blocklist. Paket disertakan tetapi harus tetap nonaktif sampai pengujian RAM; gunakan daftar kecil jika nantinya diuji.
- WAN USB tidak dibuat otomatis; protokol, APN, PIN/autentikasi, firewall zone, dan metric route harus diatur sesuai modem/adaptor. Kompatibilitas bergantung model dan mode USB.
- Modem LTE/5G dapat menarik arus tinggi; suplai 5 V port USB harus memadai dan stabil.
- Dynamic DNS memerlukan konfigurasi provider dan kredensial oleh pemilik router. Jangan simpan kredensial dalam repository.
- Dukungan software exFAT/USB tidak membuktikan port fisik berfungsi. Konektor USB masih belum dipasang dan belum diuji.
- Tidak ada perubahan langsung pada router yang sedang digunakan, tidak ada flashing otomatis, dan tidak ada merge otomatis.

### Validasi
- Sintaks shell dan tes fixture DTS dijalankan oleh workflow validasi.
- Build penuh OpenWrt 25.12.6 harus sukses untuk menyatakan image dapat dikompilasi.
- Ukuran image, isi paket, patch, manifest, dan checksum harus diperiksa pada artifact.
- Pengujian hardware USB, DDNS aktual, serta stabilitas Adblock pada RAM 64 MB masih memerlukan pengujian terpisah.

## 2026-11-16 — Restrukturisasi repository (PR #1, branch `chore/restructure-build`)

Status: **diusulkan melalui PR; belum dianggap aktif di `main` sampai PR digabung.**

### Perubahan
- Memindahkan konfigurasi build ke `config/xiaomi-mi-router-4c.config`.
- Mengekstrak aktivasi EHCI/OHCI DTS ke `scripts/enable-usb-dts.sh`.
- Menambahkan `scripts/validate-config.sh` untuk memeriksa target perangkat dan paket wajib setelah `defconfig`.
- Menambahkan workflow validasi ringan, README, panduan validasi hardware USB, dan changelog.

### Alasan
Memisahkan konfigurasi, logika skrip, dokumentasi, dan otomasi agar perubahan mudah ditinjau dan kesalahan dapat ditemukan sebelum build firmware penuh.

### Dampak dan risiko
- Perubahan file konfigurasi dapat ditinjau terpisah dari alur build.
- Kegagalan target/paket wajib akan menghentikan build lebih awal.
- Build PR menghasilkan artifact, bukan Release `latest`.
- Aktivasi DTS hanya mengatur dukungan controller; tidak memasang konektor USB fisik.

### Validasi
- Workflow validasi ringan sebelumnya lulus pada commit awal restrukturisasi.
- Build penuh untuk restrukturisasi awal belum dianggap lulus sebelum ada run sukses yang relevan.
- USB fisik tetap menunggu pemasangan port dan pengujian nyata.

## Kebijakan pencatatan berikutnya

Untuk setiap perubahan penting, catat tanggal, branch, PR, commit, file, perilaku sebelum/sesudah, alasan, risiko, tes beserta hasil, dan hal yang belum diuji. Jangan menyamakan build sukses dengan validasi hardware.
