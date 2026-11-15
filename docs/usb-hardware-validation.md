# Rencana validasi hardware USB

## Status sekarang

Firmware sudah terpasang dan berjalan baik menurut laporan pemilik perangkat. Port/konektor USB fisik belum dipasang karena komponen masih menunggu diterima. Maka seluruh fungsi USB pada hardware nyata berstatus **belum diuji**.

Dukungan software di firmware terdiri dari:
- Node host controller EHCI/OHCI yang diaktifkan melalui Device Tree (DTS).
- Paket kernel USB core, USB 2.0, OHCI, dan USB storage.
- Utilitas `usbutils`, pengelolaan block device, serta filesystem ext4/FAT.

Daftar paket bukan bukti bahwa rangkaian fisik, jalur data, dan suplai daya sudah benar.

## Sebelum memasang port

- [ ] Identifikasi pinout USB pada board berdasarkan dokumentasi/referensi board yang benar.
- [ ] Cocokkan jalur D+, D-, 5 V, dan GND; jangan menebak pinout.
- [ ] Pastikan kebutuhan resistor, proteksi ESD, dan komponen pendukung berdasarkan desain board.
- [ ] Verifikasi sumber 5 V dan batas arusnya; jangan mengandalkan asumsi.
- [ ] Periksa kemungkinan short ke ground/antarjalur sebelum memberi daya.
- [ ] Periksa kualitas solder dan isolasi mekanis agar konektor tidak mudah lepas.
- [ ] Siapkan backup konfigurasi dan metode recovery router.

Jika tidak yakin dengan skema/pinout atau pengukuran listrik, hentikan pemasangan dan minta pemeriksaan teknisi yang kompeten. Kesalahan pada jalur 5 V dapat merusak router atau perangkat USB.

## Setelah port terpasang

1. Dengan router tidak diberi daya, periksa visual solder dan kontinuitas serta pastikan tidak ada short.
2. Nyalakan router tanpa perangkat USB.
3. Periksa log kernel: `dmesg`.
4. Sambungkan perangkat USB berdaya rendah yang diketahui baik, lalu periksa `dmesg` dan `lsusb`.
5. Pastikan host controller terdeteksi tanpa error; catat pesan kernel saat perangkat dicolok dan dilepas.
6. Uji storage USB; periksa `block info` dan mount secara manual terlebih dahulu.
7. Uji baca/tulis file, unmount dengan aman, lalu uji reboot.
8. Pantau suhu, kestabilan, dan tegangan 5 V selama pemakaian.
9. Uji ZeroTier dan layanan router bersamaan untuk memastikan tidak ada regresi.

Jangan langsung mengaktifkan automount atau memasang storage berisi data penting sebelum uji manual berhasil.

## Kriteria lulus

- Host controller EHCI/OHCI terdeteksi tanpa error berulang.
- Perangkat USB ter-enumerasi secara konsisten saat colok/cabut.
- Storage terdeteksi dan dapat dibaca/tulis tanpa error I/O.
- Router tidak reboot sendiri, hang, atau mengalami penurunan layanan.
- Tegangan dan suhu berada dalam batas aman komponen dan tidak ada panas berlebih.
- Hasil tetap konsisten setelah reboot dan pengujian layanan lain.

## Catatan hasil pengujian

Isi bagian ini setelah pengujian nyata dilakukan; jangan mengisi dengan asumsi.

| Tanggal | Perangkat USB | Hasil deteksi | Baca/tulis | Tegangan/suhu | Catatan |
|---|---|---|---|---|---|
| Belum diuji | — | — | — | — | Port fisik belum dipasang |

Jangan menyatakan USB siap produksi sampai semua pengujian yang relevan selesai.
