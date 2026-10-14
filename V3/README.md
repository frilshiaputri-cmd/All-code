# IronSoul K5-HUB V3

Versi V3 diletakkan di folder `V3/` agar file lama di root repository **All-code** tetap aman dan tidak tertimpa.

## Struktur

- `LOADER.lua` — entry point V3 (akan diisi setelah modul siap).
- `Config/Settings.lua` — pengaturan umum.
- `Systems/AutoRedeem.lua` — modul auto redeem yang akan diperbaiki.
- `Systems/AutoFarm.lua` — modul auto farm.
- `Systems/AutoSkill.lua` — modul auto skill.

## Aturan Auto Redeem yang ditargetkan

1. Jangan berjalan otomatis hanya karena player baru masuk server; jalankan saat loader V3 dieksekusi manual.
2. Jika batas level 30 tercapai di dungeon, minta kembali ke lobby terlebih dahulu.
3. Mulai redeem hanya setelah berada di lobby dan remote kode tersedia.
4. Jangan menganggap proses selesai hanya karena seluruh permintaan dikirim. Catat status hasilnya.
5. Jangan kick player sebelum daftar kode selesai diproses; opsi kick akan dapat dimatikan.
6. Jangan mengubah atau menghapus file lama di root repository.

> Status: kerangka V3 dibuat. Modul runtime belum dianggap siap dipakai sampai implementasi dan pengujian selesai.
