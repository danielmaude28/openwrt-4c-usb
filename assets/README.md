# Assets

Folder ini digunakan untuk menyimpan aset pendukung proyek firmware Xiaomi Mi Router 4C yang memang perlu dilacak bersama source code.

## Isi folder

Letakkan di sini hanya aset sumber atau dokumentasi yang dibutuhkan untuk memahami dan memelihara proyek, misalnya:

- diagram atau gambar referensi perangkat dan modifikasi hardware;
- gambar/skema pemasangan port USB, bila tersedia;
- berkas pendukung non-rahasia yang digunakan dalam dokumentasi atau proses pengembangan.

## Hasil build firmware

Firmware hasil kompilasi dan berkas besar sementara sebaiknya **tidak** di-commit ke folder ini. Hasil build dipublikasikan melalui GitHub Actions artifacts atau GitHub Releases sesuai workflow di `.github/workflows/build.yml`.

## Aturan pemeliharaan

- Gunakan nama file yang jelas dan konsisten.
- Sertakan sumber, versi, atau keterangan singkat untuk aset eksternal.
- Jangan menyimpan token, password, private key, kredensial, atau data pribadi.
- Jangan menganggap gambar atau diagram sebagai bukti pengujian perangkat keras.
- Perbarui README ini ketika jenis aset yang dilacak berubah.

## Status

README ini menetapkan fungsi folder `assets/`. Aset yang belum tersedia atau belum diverifikasi tidak dianggap sudah dibuat maupun diuji.
