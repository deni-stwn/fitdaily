# Review — 01-onboarding
Status: DONE
Screen: Splash Screen (`683:53900`) + Onboarding (`683:53078`) · feature `onboarding`

## Kelengkapan input

| Input | Status |
|---|---|
| Screenshot | ✅ `Onboarding.png` (880×1912 = @2x) |
| Spec | ✅ `code.dart` (plugin Figma to Code, Flutter) |
| Aset logo | ✅ `assets/Layer_1.svg` (42.18×32.90) |
| Background pattern | ✅ `assets/Rectangle 100.png` (880×1912 @2x, pola memudar ke bawah) |
| Splash | ✅ `splash.png` + `splash.dart` (ditambahkan setelah review pertama) |
| **Blur glow di button** | ⚠️ Ellipse putih 139.13×14 di atas button ada di spec, tapi efek *layer blur*-nya tidak ikut terexport (di screenshot terlihat buram). Nilai blur perlu dicek di Figma. |
| `notes.md` | kosong |
| `_components/button/` | ❌ kosong — hanya varian *Default · Large* yang bisa dibangun dari layar ini |

## Struktur layar (atas → bawah, koordinat frame 440×956)

1. **Status bar** (0–60) — UI sistem → tidak dibuat, pakai `SafeArea`.
2. **Logo** — Row center, top 92.55: SVG 42.18×32.90 + gap 8.83 + teks "FitDaily".
3. **Judul** — "Live fit Every Day", center, top 392, lebar 357.
4. *(ruang kosong)*
5. **Button "Continue"** — 400×48, left/right 20, top 828.
6. **Link** — "Already Had an account ?" + gap 8 + "Sign In", center, top 892 (16 di bawah button).
7. **Home indicator** (922–956) — UI sistem → tidak dibuat.

## Komponen (reuse / baru / khusus layar)

| Elemen | Keputusan | Detail |
|---|---|---|
| Button "Continue" | **Baru (shared)** → `AppButton` (`lib/shared/widgets/app_button.dart`) | Figma *Button · Variant=Default · Large*: bg `bgBrand`, radius full, tinggi 48, padding 16, label `bodySmallStrong` putih, glow ellipse atas + "Button Effect" (3 inner shadow). Lebar dari parent (stretch). |
| Logo + "FitDaily" | **Baru (shared)** → `AppLogo` (`lib/shared/widgets/app_logo.dart`) | Dipakai juga di Sign In (dan kemungkinan Splash). |
| Link "Already Had an account ? Sign In" | Khusus layar → `presentation/widgets/` | Mungkin muncul lagi di Sign Up dengan teks berbeda — jadikan shared bila nanti terpakai ulang. |
| Background pattern | Khusus/shared → `AppBackground` (bila pola sama di semua layar) | Menunggu aset. |

## Aset

| File | Tujuan |
|---|---|
| `assets/Layer_1.svg` | → `assets/images/logo_mark.svg`, dipakai `AppLogo` ukuran 42.18×32.90 |
| `assets/Rectangle 100.png` | → `assets/images/bg_pattern.png`, full-screen `BoxFit.cover` di atas `AppColors.bg` (dipakai `AppBackground`) |

## Token (cocok / di luar token)

Cocok:
- `#1E1E1E` → `AppColors.bg` · putih → `AppColors.text` · `#FFFFFFB2` → `AppColors.textSecondary` · `#5B23FF` → `AppColors.bgBrand`
- "FitDaily" 24 / h1.17 / w600 → `AppTextStyles.headingMedium`
- Judul Instrument Serif 48 / h1.17 → `AppTextStyles.display` (Figma `display`)
- "Continue" 12 / w550 / ls 0.5 → `AppTextStyles.bodySmallStrong`
- Link 14 / w450 / ls 0.5 → `AppTextStyles.bodyMedium` (warna `textSecondary` / `text`)
- Padding button 16 → `AppSpacing.s3` · gap link 8 → `AppSpacing.s2` · radius 100 → `AppRadius.full`
- Inner shadow button → spec "Button Effect" (`AppShadows`)

Di luar token (dipakai literal + `// figma`):
- Margin horizontal button **20** (kemungkinan dipakai di banyak layar → usul token `AppSpacing.pagePadding = 20` bila muncul lagi di layar berikutnya)
- Gap logo **8.83**, ukuran logo **42.18×32.90**, lebar judul **357**
- Glow: ellipse **139.13×14**, warna `textSecondary`, posisi top **-7** (blur: belum diketahui)

## Splash Screen (tambahan)

- Background: `LinearGradient` atas→bawah `#5B23FF` (`AppColors.bgBrand`) → `#120A2F` (**tidak ada token** → usul `AppColors.splashGradientEnd`). Tanpa pola.
- Logo di tengah layar (center X & Y): mark **77.23×60.25** + gap **16.17** + "FitDaily" Instrument Sans **51.76 / h1.5 / w500 / ls -2.83** (bukan token — angka literal).
- Logo splash bukan sekadar versi besar logo onboarding (onboarding: 24 / w600 / ls 0) → `AppLogo` punya 2 ukuran: `AppLogoSize.regular` (onboarding/sign in) dan `AppLogoSize.large` (splash), masing-masing dengan angka Figma sendiri.
- Mark memakai SVG yang sama (`logo_mark.svg`, rasio sama 1.28).

## Rencana file

```
lib/features/onboarding/
└── presentation/
    ├── pages/splash_page.dart
    ├── pages/onboarding_page.dart
    └── widgets/sign_in_prompt.dart
lib/shared/widgets/app_button.dart     (+ export di widgets.dart)
lib/shared/widgets/app_logo.dart
lib/shared/widgets/app_background.dart  (pola bg, opsional per layar)
assets/images/logo_mark.svg (+ bg_pattern.png)
lib/config/routing/route_names.dart    → kSplashPage = '/splash', kOnboardingPage = '/onboarding', placeholder kSignInPage / kSignUpPage
lib/config/routing/app_router.dart     → GoRoute splash (initialLocation) + onboarding (di luar shell bottom-nav)
assets/translations/en.json, ar.json   → onboarding.* (jika pakai LocaleKeys)
```

Layout: `Scaffold(bg)` → `SafeArea` → `Column`: logo (top 32.55.h di bawah status bar) → jarak 266.55.h → judul → `Spacer` → button → 16.h → link → 12.h. Semua jarak vertikal pakai `.h` agar proporsional dengan tinggi layar.

## Pertanyaan

1. **Background pattern** — tolong export layer *Background* di frame Onboarding (PNG 2x) ke `assets/`. Apakah pola ini sama di semua layar? — saran: ya, dibuat `AppBackground` shared.
2. **Blur glow button** — berapa nilai *Layer blur* ellipse di dalam button (pilih ellipse → panel Effects)? — saran: kalau sulit dicek, aproksimasi blur 10 dan ditandai sebagai deviasi.
3. **AppButton varian** — export `_components/button` dulu agar semua varian (Secondary/Outline/Tertiary, Pressed/disabled, medium/small) dibangun sekaligus, atau bangun *Default · Large* saja sekarang? — saran: bangun *Default · Large* + struktur enum lengkap, status 🟡, varian lain diisi saat export tersedia.
4. **Tombol "Continue"** mengarah ke mana? — saran: layar *Auth - Sign Up* (sementara placeholder sampai layar itu dibuat).
5. **Link "Sign In"** — saran: ke *Auth - Sign In* (placeholder sampai `02-auth_sign_in` selesai).
6. **Layar awal app** — jadikan Onboarding sebagai `initialLocation` (menggantikan Home sementara, sampai Splash dibuat)? — saran: ya.
7. **Struktur feature** — layar ini statis (tanpa data). Cukup `presentation/` saja, atau tetap Mason lengkap (data/domain/cubit kosong)? — saran: `presentation/` saja; data/domain ditambahkan hanya jika ada data.
8. **Teks** — pakai `LocaleKeys` (en.json, ar.json diisi sama dulu) atau teks langsung persis Figma? — saran: `LocaleKeys`, isi persis teks Figma (termasuk "Already Had an account ?").

9. **Splash** — tampil berapa lama lalu ke Onboarding? — saran: 2 detik, lalu `go` ke Onboarding (tanpa bisa back).
10. **Native splash** (`flutter_native_splash`, sebelum Flutter jalan) — saran: warna solid `#5B23FF` tanpa logo, agar tidak ada kedipan putih sebelum Splash Flutter muncul.
11. **Warna `#120A2F`** — saran: jadikan token `AppColors.splashGradientEnd`.

## Jawaban

1. Background sudah di `assets/`; dipakai bersama hampir semua layar (beberapa tidak) → `AppBackground` shared, opsional per layar.
2. Ya — blur glow diaproksimasi 10 (deviasi dicatat).
3. Ya — `AppButton` Default · Large + enum lengkap, status 🟡.
4. Ya — Continue → Auth - Sign Up (placeholder).
5. Ya — Sign In → Auth - Sign In (placeholder).
6. Ya — dan Splash Screen digabung ke folder ini → app mulai dari Splash, lalu Onboarding.
7. Ya — `presentation/` saja.
8. Ya — `LocaleKeys`, teks persis Figma.
9. Ya — splash 2 detik lalu `go` ke Onboarding.
10. Ya — native splash solid `#5B23FF` tanpa logo.
11. Ya — token `AppColors.splashGradientEnd`.

## Hasil

**File baru**
- `lib/features/onboarding/presentation/pages/splash_page.dart`, `onboarding_page.dart`
- `lib/features/onboarding/presentation/widgets/sign_in_prompt.dart`
- `lib/shared/widgets/app_button.dart` (🟡 Default · Large), `app_logo.dart`, `app_background.dart`, `placeholder_page.dart`
- `assets/images/logo_mark.svg`, `assets/images/bg_pattern.png`
- `test/visual/render_screen.dart`, `test/visual/screens_render_test.dart` (harness verifikasi visual)

**File diubah**
- `lib/config/theme/app_colors.dart` (+ `splashGradientEnd`), `app_text_styles.dart` (fontWeight ≤ w500 — cegah synthetic bold)
- `lib/config/routing/route_names.dart`, `app_router.dart` (splash initial, onboarding, placeholder sign-in/sign-up)
- `lib/core/constants/app_strings.dart` (appName = FitDaily), `assets/translations/en.json`, `ar.json`, `lib/generated/locale_keys.g.dart`
- `lib/shared/wrappers/app_wrapper.dart` (hapus padding bawah global → full-bleed) + `custom_bottom_nav_bar.dart` (SafeArea sendiri)
- `flutter_native_splash.yaml` + file native Android/iOS hasil generate (solid #5B23FF)
- `pubspec.yaml` (assets/images), `analysis_options.yaml` (exclude figma-code)

**Verifikasi**: analyze bersih · 10 test lulus · render 440×956 dibandingkan dengan Figma: logo, judul, tombol, link, pola bg, glow, posisi splash cocok.

**Deviasi**
1. Label "Continue": Figma tampak abu #E4E4E4 & lebih tipis, spec bilang putih `text-default` → mengikuti spec; perlu dicek di Figma.
2. Glow tombol: blur tidak ada di export → 20 (disetel visual terhadap screenshot).
3. Inner shadow "Button Effect" dibuat dengan custom painter (sigma = blur/2).
4. `splash.png` bukan export 2x (285×621) → warna gradient tidak bisa diverifikasi presisi; nilai dari spec.
5. Status Pressed/disabled `AppButton` belum punya visual (belum ada spec).
