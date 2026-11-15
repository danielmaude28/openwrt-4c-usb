# Rencana validasi hardware USB

## Status sekarang

Firmware sudah terpasang dan berjalan baik menurut pengujian pemilik perangkat. Port/konektor USB fisik belum dipasang; komponen masih dipesan. Karena itu, semua butir di bawah ini berstatus **belum diuji secara fisik**.

## Sebelum memasang port

- [ ] Identifikasi pinout USB pada board berdasarkan dokumentasi/referensi board yang benar.
- [ ] Cocokkan jalur D+, D-, 5 V, dan GND; jangan menebak pinout.
- [ ] Periksa kebutuhan resistor, proteksi, dan komponen pendukung berdasarkan desain board.
- [ ] Pastikan sumber 5 V dan kemampuan arusnya memadai.
- [ ] Periksa kemungkinan short ke ground/antarjalur sebelum memberi daya.
- [ ] Siapkan backup konfigurasi dan metode recovery router.

## Setelah port terpasang

1. Periksa visual solder dan kontinuitas saat router tidak diberi daya.
2. Nyalakan router tanpa perangkat USB terlebih dahulu.
3. Periksa log kernel: `dmesg`.
4. Sambungkan perangkat USB berdaya rendah yang diketahui baik, lalu periksa `dmesg` dan `lsusb`.
5. Uji storage USB; periksa `block info` dan mount secara manual terlebih dahulu.
6. Uji baca/tulis file, unmount dengan aman, lalu uji reboot.
7. Pantau suhu, kestabilan, dan tegangan 5 V selama pemakaian.
8. Uji ZeroTier dan layanan router bersamaan untuk memastikan tidak ada regresi.

## Kriteria lulus

- Host controller EHCI/OHCI terdeteksi tanpa error berulang.
- Perangkat USB ter-enumerasi secara konsisten.
- Storage terdeteksi dan dapat dibaca/tulis tanpa error I/O.
- Router tidak reboot sendiri, hang, atau mengalami penurunan layanan.
- Tegangan dan suhu berada dalam batas aman komponen.

Jangan menyatakan USB siap produksi sampai semua pengujian yang relevan selesai.
