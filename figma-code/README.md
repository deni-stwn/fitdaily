# figma-code — cache spesifikasi desain per layar

Folder ini menyimpan spesifikasi Figma per layar supaya AI **tidak perlu memanggil Figma MCP berulang**
(kuota terbatas) dan supaya slicing bisa jalan **tanpa MCP** (export manual).

## Struktur

```
figma-code/
├── _components/<name>/       # export komponen Figma (semua varian): button, input, checkbox, …
└── NN-<screen_slug>/         # contoh: 01-auth_sign_in, 02-home — NN = urutan slicing
    ├── screenshot.png        # WAJIB — export frame @2x (target visual)
    ├── spec.txt              # dari tool/figma_export.dart (sumber angka) — atau spec.html/spec.css dari Dev Mode
    ├── node.json             # raw Figma REST (dari skrip)
    ├── assets/               # ikon/gambar yang dipakai layar (SVG/PNG dari Figma)
    └── notes.md              # opsional — node ID, interaksi, state, catatan khusus
```

`<screen_slug>` = nama layar di `docs/ui/SCREENS.md`, huruf kecil, spasi/simbol → `_`.
Folder `_components/<name>/` isinya sama (screenshot, spec, assets) tapi untuk **component set** (pilih set ungu putus-putus agar semua varian ikut).

## Alur

1. Isi folder → 2. ketik `review 01-auth_sign_in` → 3. jawab pertanyaan → 4. ketik `mulai`.

## Cara 1 — Skrip export (disarankan, tanpa MCP)

1. Buat token: Figma → Settings → Security → **Personal access tokens** (scope: *File content: read*).
2. Di terminal kamu (jangan tempel token ke chat AI):
   ```bash
   export FIGMA_TOKEN=figd_xxx
   fvm dart run tool/figma_export.dart 84:348 254:2529 683:53091
   # atau pakai URL: fvm dart run tool/figma_export.dart "https://www.figma.com/design/...?...node-id=683-53091"
   ```
3. Hasil per node: `spec.txt` (pohon layer: ukuran, posisi, auto-layout, warna, font, instance komponen),
   `node.json` (raw), `screenshot.png` @2x, `assets/` (SVG ikon + PNG gambar).

Satu kali jalan = 1 panggilan node + beberapa panggilan gambar, jadi gabungkan banyak node dalam satu perintah.

## Cara 2 — Export manual (tanpa MCP)

0. Seat *View* tidak bisa Dev Mode / plugin → **File → Duplicate to your drafts** dulu, kerjakan di salinan itu.
1. Pilih frame di Figma → **Export** → PNG **2x** → simpan sebagai `screenshot.png`.
2. Ambil kode/angka (pilih salah satu):
   - Plugin **Figma to Code** (HTML/Tailwind/Flutter) → pilih frame → salin output → `spec.html` (atau `spec_flutter.dart`). Paling mirip alur web.
   - **Dev Mode** (`Shift+D`) → panel *Code* → CSS → `spec.css` (butuh seat Dev/Full).
   - Klik kanan elemen → **Copy/Paste as → Copy as code → CSS** → tempel ke `spec.css` dengan komentar nama layer.
   Output plugin hanya **referensi angka** — AI tetap memakai token & komponen project, bukan menyalin kodenya.
3. Export ikon/ilustrasi yang tampil di layar ke `assets/` (SVG untuk ikon, PNG 2x/3x untuk gambar).
4. Isi `notes.md` dengan node ID frame (lihat `SCREENS.md`) + interaksi yang tidak terlihat di gambar.

## Cara 3 — Via MCP

AI memanggil `get_design_context` sekali per layar, lalu **menyimpan** hasilnya ke folder di atas
(`spec.html` = kode referensi, `screenshot.png`, aset yang diunduh). Sesi berikutnya cukup membaca folder ini.
