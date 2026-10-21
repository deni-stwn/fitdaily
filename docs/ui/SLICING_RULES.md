# Figma → Flutter Slicing Rules

Project ini **slicing-only**: tidak ada API/backend. Target: hasil **identik dengan Figma**,
dengan struktur Clean Architecture project ini.

## 0. Wajib dibaca sebelum menulis kode UI

1. `docs/ui/COMPONENTS.md` — komponen yang sudah ada / harus dipakai ulang.
2. `docs/ui/SCREENS.md` — node ID layar, feature folder, status.
3. Token di `lib/config/theme/` (`AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`).

## 1. Sumber data desain (urutan prioritas)

1. **Cache lokal** `figma-code/<screen_slug>/` — kalau sudah ada, pakai ini. Jangan panggil Figma MCP lagi untuk layar yang sama.
   Baca `spec.txt` (angka pasti) + `screenshot.png` (target visual) + `assets/`.
2. **Skrip REST API** (tanpa MCP) — user menjalankan `dart run tool/figma_export.dart <node-id>...` dengan `FIGMA_TOKEN`;
   hasilnya masuk ke cache di atas. Kalau cache belum ada, minta user menjalankannya (sebutkan node ID dari `SCREENS.md` / `COMPONENTS.md`).
3. **Figma MCP** — `get_design_context` (spec + screenshot) per layar/komponen.
   Kuota MCP **terbatas** (seat View). Satu layar = satu panggilan `get_design_context`; panggil child node hanya jika respons ditandai *sparse*.
   Setelah berhasil, **simpan hasilnya** ke `figma-code/<screen_slug>/` (lihat `figma-code/README.md`) agar tidak memanggil ulang.
4. **Manual export** dari user (screenshot + CSS/HTML Dev Mode) di `figma-code/<screen_slug>/`.

Kalau tidak ada spec (hanya screenshot) → **TANYA user**, jangan menebak angka dari gambar.

## 2. Anti-halu (wajib)

- **Dilarang menebak** ukuran, spacing, warna, font, radius. Semua angka berasal dari spec Figma.
- **Dilarang hardcode** hex / ukuran font / font family di widget. Pakai token:
  - warna → `AppColors.<token>` (nama = variabel Figma `--color-*` dalam camelCase)
  - teks → `AppTextStyles.<style>` (`heading/medium` → `headingMedium`, `body/small/strong` → `bodySmallStrong`), override hanya `color` bila perlu
  - spacing → `AppSpacing.s1..s4`; nilai Figma di luar skala → pakai angka literal Figma + `.w/.h` (jangan dibulatkan)
  - radius → `AppRadius.*` + `.r`
- Nilai Figma yang tidak punya token: tulis angka persis + komentar `// figma: <node-id>`; kalau dipakai ≥ 2 kali, jadikan token dulu.
- Teks, label, dan data dummy **persis** seperti di Figma (huruf besar/kecil, tanda baca).
- Aset (gambar/ikon/ilustrasi) **diunduh dari Figma**, tidak digambar ulang, tidak diganti ikon Material yang "mirip".
- Ada yang ambigu (interaksi, state, scroll) → sebutkan asumsi di ringkasan, atau tanya.

## 3. Pakai ulang komponen (konsistensi)

- Instance komponen Figma (Button, Input, Title Bar, …) → **wajib** pakai widget di `COMPONENTS.md`; cukup ganti props.
- Komponen belum ada → buat di `lib/shared/widgets/` **dengan semua varian Figma** (bukan hanya yang dipakai layar ini), daftarkan di `COMPONENTS.md`.
- Dilarang membuat widget duplikat/mirip. Beda kecil → tambah parameter/varian di komponen yang ada.
- Widget yang hanya dipakai satu feature → `lib/features/<feature>/presentation/widgets/`.
- Varian pakai `enum` (`AppButtonVariant.secondary`), bukan boolean bertumpuk.

## 4. Layout & ukuran

- Frame Figma 440×956; ScreenUtil `designSize` = `AppDesign.frameSize`. Ukuran pakai `.w` (lebar/horizontal), `.h` (tinggi/vertikal), `.r` (radius), `.sp` (font, sudah di `AppTextStyles`).
- Terjemahkan auto-layout Figma ke `Row`/`Column`/`Padding`/`gap` (SizedBox). Absolute positioning (`Stack`/`Positioned`) **hanya** untuk elemen yang memang overlap (glow, dekorasi, badge).
- Status bar & home indicator di Figma = UI sistem → **jangan digambar**; pakai `SafeArea`.
- Konten lebih tinggi dari layar → scrollable (`SingleChildScrollView` / `CustomScrollView`), bottom nav tetap.
- Efek "Button Effect" (inner shadow) & blur: lihat `AppShadows`; gunakan `BackdropFilter`/gradient overlay. Sebutkan bila hanya aproksimasi.

## 5. Struktur kode (jangan diubah)

- Layar baru → feature di `lib/features/<feature>/` (lihat `SCREENS.md`). Gunakan Mason: `mason make feature --feature_name <x> --entity_name <X>`.
- Data dummy → `data/datasources/<feature>_local_data_source.dart` (inline atau JSON di `assets/dummy/` + `DummyAssets`). Tidak ada Dio/HTTP.
- UI di `presentation/pages` + `presentation/widgets`; state via Cubit (`Loading/Loaded/Error`).
- Route → `lib/config/routing/route_names.dart` + `app_router.dart`.
- String UI → `assets/translations/*.json` + `LocaleKeys` bila feature sudah memakai localization; selain itu ikuti teks Figma persis.

## 6. Alur per layar: `review` → jawab → `mulai`

1. User mengisi `figma-code/NN-<screen_slug>/` (screenshot, spec, assets, notes).
2. **`review NN-<screen_slug>`** → skill `slicing-review`: baca input, petakan komponen (reuse/baru),
   cek aset & token, susun rencana file, ajukan pertanyaan bernomor (dengan saran default).
   Hasil ditulis ke `figma-code/NN-<screen_slug>/review.md`. **Tidak ada kode yang ditulis.**
3. User menjawab (atau "ikut saran").
4. **`mulai`** → skill `slicing-mulai`: catat jawaban di `review.md`, bangun token → aset → komponen → layar → route,
   verifikasi (`analyze`, test, render `test/visual` → `build/visual/` lalu bandingkan dengan screenshot Figma), update `COMPONENTS.md`, `SCREENS.md`, `review.md`.

## 7. Ikon & aset

- Ikon dari Figma page Component → simpan SVG di `assets/icons/<nama-figma>.svg` (nama sama dengan `Variant=<nama>`).
- Render SVG memerlukan `flutter_svg` (belum terpasang — minta izin user sebelum menambah dependency).
- Gambar/ilustrasi → `assets/images/` (PNG @2x/@3x atau SVG sesuai export Figma).
- Daftarkan folder aset di `pubspec.yaml`.

## 8. Catatan teknis (hasil verifikasi)

- **Jangan pakai `FontWeight.w600+` dengan Instrument Sans** (variable font): engine menambah *synthetic bold* di atas `fontVariations`.
  `AppTextStyles` sudah membatasi `fontWeight` ≤ w500; berat sebenarnya dari `FontVariation.weight`. Untuk style literal, ikuti pola yang sama.
- Background full-bleed: `AppWrapper` tidak memberi padding bawah global — tiap layar pakai `SafeArea` sendiri.
- Screenshot Figma untuk verifikasi harus **export PNG 2x** (bukan screen capture) agar warna & ukuran bisa dibandingkan.
