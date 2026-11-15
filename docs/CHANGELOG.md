# Riwayat perubahan

Dokumen ini mencatat perubahan pada repository, alasan, dampak, dan status validasinya. Catatan terbaru berada di bagian paling atas. Perubahan dokumentasi/otomasi tidak otomatis berarti firmware telah dipasang atau diuji di router.

## 2026-11-16 — Restrukturisasi repository (PR #1, branch `chore/restructure-build`)

Status: **diusulkan melalui PR; belum dianggap aktif di `main` sampai PR digabung.**

### Perubahan
- Memindahkan konfigurasi build dari isi workflow ke `config/xiaomi-mi-router-4c.config`.
- Mengekstrak aktivasi node EHCI/OHCI ke `scripts/enable-usb-dts.sh`.
- Menambahkan `scripts/validate-config.sh` untuk memeriksa target perangkat dan paket wajib setelah `defconfig`.
- Menambahkan workflow `validate.yml` untuk pemeriksaan sintaks shell dan opsi konfigurasi dasar pada PR/push.
- Merapikan `build.yml`: build dari `main` dipublikasikan sebagai Release bertag `latest`; build manual pada branch lain hanya mengunggah artifact bernomor.
- Menambahkan peta file, cara kerja build, daftar paket, batas validasi, dan checklist hardware USB.

### Alasan
Memisahkan konfigurasi, logika skrip, dokumentasi, dan otomasi agar lebih mudah ditinjau serta mengurangi perubahan berulang di satu file workflow. Pemeriksaan cepat membantu menemukan kesalahan struktur sebelum build firmware yang lebih berat.

### Dampak
- Perubahan file konfigurasi dapat ditinjau terpisah dari alur build.
- Kegagalan target/paket wajib akan menghentikan build lebih awal.
- Release `latest` dirancang untuk mengikuti build sukses dari `main`; belum berlaku sebelum workflow ini masuk ke `main`.
- Tidak ada perubahan langsung pada router yang sedang digunakan.
- Aktivasi DTS hanya mengatur dukungan controller pada firmware; tidak membuat konektor USB fisik.

### Risiko dan hal yang perlu diverifikasi
- Pastikan path dan nama DTS cocok dengan sumber OpenWrt `v25.12.6`.
- Periksa hasil `defconfig` karena feed paket dapat berubah.
- Build penuh pada branch PR masih perlu sukses sebelum perubahan dianggap tervalidasi.
- Fungsi USB fisik tetap menunggu pemasangan port dan pengujian nyata.

### Validasi
- Workflow validasi repository: periksa status run terbaru pada tab Actions.
- Build OpenWrt penuh: belum dinyatakan lulus untuk versi restrukturisasi sampai ada run sukses.
- Pengujian USB fisik: belum dilakukan karena port belum dipasang.

## Kebijakan pencatatan berikutnya

Untuk setiap perubahan penting, tambahkan:
1. Tanggal, branch, PR, dan commit.
2. File yang berubah.
3. Perilaku sebelum dan sesudah perubahan.
4. Alasan teknis dan dampak terhadap image/perangkat.
5. Risiko, kompatibilitas, dan langkah pemulihan bila relevan.
6. Tes yang dijalankan beserta hasilnya.
7. Hal yang belum diuji; jangan menyamakan build sukses dengan validasi hardware.
