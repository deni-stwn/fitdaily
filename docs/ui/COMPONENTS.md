# Component Registry — Fitdaily (Product)

**Sumber kebenaran untuk komponen UI.** AI WAJIB membaca file ini sebelum membuat widget apa pun,
dan WAJIB memperbaruinya setiap kali membuat / mengubah komponen.

- Figma page: **↳ Component** (`79:333`) · file key `0JJ9zgqULqqfGnLLwZx8kA`
- Lokasi kode komponen shared: `lib/shared/widgets/` (satu komponen = satu file, export lewat `widgets.dart`)
- Status: ⬜ belum dibuat · 🟡 sebagian varian · ✅ lengkap

## Cara pakai registry

1. Elemen di layar Figma berupa **instance** komponen di bawah → pakai widget yang terdaftar, cukup ganti props (label, icon, variant).
2. Belum dibuat (⬜) → buat dulu komponennya (semua varian dari Figma), baru lanjut layar.
3. Elemen mirip tapi tidak ada di registry → tanyakan ke user: tambah varian/param ke komponen yang ada, atau komponen baru.
4. Setelah membuat komponen → ubah status, isi kolom **Widget / File**, dan tambah contoh pemakaian di bagian *Usage*.

---

## Foundations (tokens) — ✅

| Token | File | Contoh |
|---|---|---|
| Warna (`--color-*`, `--ramp-*`) | `lib/config/theme/app_colors.dart` | `AppColors.bgSecondary`, `AppColors.textTertiary` |
| Tipografi (`heading/*`, `body/*`, `display`) | `lib/config/theme/app_text_styles.dart` | `AppTextStyles.bodyMediumStrong` |
| Spacing (`--spacer-*`) | `lib/config/theme/app_dimens.dart` | `AppSpacing.s3.w` |
| Radius (`--radius-*`) | `lib/config/theme/app_dimens.dart` | `AppRadius.xLarge.r` |
| Effect "Button Effect" (inner shadow) | `lib/config/theme/app_dimens.dart` → `AppShadows` | lihat catatan di file |
| Frame size 440×956 | `AppDesign.frameSize` (dipakai ScreenUtil) | — |

---

## Components

| Status | Figma component | Node ID | Varian (Figma) | Widget / File |
|:--:|---|---|---|---|
| 🟡 | **Button** | `84:348` | Variant: Default · Secondary · Outline · Tertiary — State: Default · Pressed · disabled — Size: Large 48 · medium 40 · small 32 | `AppButton` → `app_button.dart` — **baru Default · Large** (dari 01-onboarding); varian lain throw sampai `_components/button` diexport; state Pressed/disabled belum ada visual |
| ⬜ | **Input** | `254:2529` | Variant: Default · Dropdown · Textarea · prefix — State: Default · Active · Error | `AppTextField` → `app_text_field.dart` |
| ⬜ | **navbar** | `360:7737` | Home · Activity · Devices · Goals | `AppNavBar` → ganti `lib/shared/navigation/custom_bottom_nav_bar.dart` |
| ⬜ | **Tab** | `598:31871` | 2 Coloum · 3 Coloum | `AppSegmentedTab` → `app_segmented_tab.dart` |
| ⬜ | **Title Bar** | `360:8692` | Default · Menu · Notification · sub screen | `AppTitleBar` → `app_title_bar.dart` |
| ⬜ | **Header** | `619:6259` | Type: Button · Icon Trailing · Detail | `SectionHeader` → `section_header.dart` |
| ⬜ | **Checkbox** | `266:5647` | default · active | `AppCheckbox` → `app_checkbox.dart` |
| ⬜ | **Chips** | `358:4997` | Success · Warning · Danger | `StatusChip` → `status_chip.dart` |
| ⬜ | **Toggle** | `276:2574` | Inactive · Active | `AppToggle` → `app_toggle.dart` |
| ⬜ | **Avatar** | `625:6444` | xs 48 · sm 72 · md 124 · lg 248 | `AppAvatar` → `app_avatar.dart` |
| ⬜ | **Weather Badge** | `691:12791` | Partly Cloudy · Thunderstorm · Mostly Cloudy · Rainy · Windy · Sunny | `WeatherBadge` → `weather_badge.dart` |
| ⬜ | **Status and Weather** | `692:13426` | — | `StatusWeatherBar` → `status_weather_bar.dart` |
| ⬜ | **Legend Item** | `608:20529` | blue · teal · green · orange · red · maroon · dark red | `LegendItem` → `legend_item.dart` |
| ⬜ | **Activity Duration Container** | `612:6066` | — | `ActivityDurationTag` → `activity_duration_tag.dart` |
| ⬜ | **Device State** | `644:25566` | Pairing · Connecting · Disconnect | `DeviceStateTile` → `device_state_tile.dart` |
| ⬜ | **Activity Info** | `644:25769` | Running · Cycling · Walking · Exercise | `ActivityInfoTile` → `activity_info_tile.dart` |
| ⬜ | **Accordion** | `652:32627` | Open · Close | `AppAccordion` → `app_accordion.dart` |
| ⬜ | **Goal Item** | `667:38565` | Default · Selected | `GoalItem` → `goal_item.dart` |
| ⬜ | **Menu Item** | `658:38035` | — | `MenuItem` → `menu_item.dart` |
| ⬜ | **Blurred Effect** | `691:12270` | bottom · full | `BlurredOverlay` → `blurred_overlay.dart` |
| ⬜ | **Card** | `619:6160` | Default | `AppCard` → `app_card.dart` |
| ⬜ | **Quotes** | `624:6398`… | Quotes 1–4 | `QuoteCard` → `quote_card.dart` |
| ⬜ | **Modal** | `691:13113`… | Choose Target · Start Session · Input Target · Active Session · Finish Session | `presentation/widgets/` di feature `activity` (bukan shared) |
| ⬜ | **Segmented Progress Bar** | `614:6398` | v1 · v2 · v3 · v4 | `SegmentedProgressBar` → `charts/segmented_progress_bar.dart` |
| ⬜ | **Graph** | `604:11760` | Daily · Weekly · Yearly · Small 1–5 · Line · Empty · Candle · Donut · Donut 2 | `lib/shared/widgets/charts/` (satu file per tipe) |
| ⬜ | **Icons** | `79:1578` | 216 ikon (`Variant=<nama>, Type=Fill/…`) | SVG di `assets/icons/` — lihat aturan ikon |
| ⬜ | **Social Media icon set** | `625:8798` | 276 ikon | SVG di `assets/icons/social/` |
| ✅ | *(custom)* **Logo FitDaily** | `683:53078` / `683:53900` | regular (onboarding, sign in) · large (splash) | `AppLogo` → `app_logo.dart` |
| ✅ | *(custom)* **Background pattern** | layer "Background" | — (dipakai hampir semua layar, opsional) | `AppBackground` → `app_background.dart` |
| — | *(custom)* Placeholder route | — | — | `PlaceholderPage` → `placeholder_page.dart` (sementara, untuk layar yang belum di-slicing) |
| — | Status bar / Home bar (iPhone 15 Pro Max) | `651:29874` / `651:29875` | — | **Jangan dibuat** — itu UI sistem, ganti dengan `SafeArea` |

---

## Usage

```dart
// AppButton — Figma Button (84:348). Default · Large (ukuran hug, atau fullWidth untuk "Fill").
AppButton(label: 'Continue', fullWidth: true, onPressed: () {});

// AppLogo — logo + wordmark "FitDaily".
const AppLogo();                         // regular: onboarding / sign in
const AppLogo(size: AppLogoSize.large);  // splash

// AppBackground — bg + pola diamond (taruh di body Scaffold, isi dengan SafeArea).
Scaffold(body: AppBackground(child: SafeArea(child: ...)));
```
