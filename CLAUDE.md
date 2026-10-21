# FitDaily — Flutter (slicing-only)

Aplikasi Flutter hasil slicing dari Figma **Fitdaily (Product)** (`0JJ9zgqULqqfGnLLwZx8kA`).
Tidak ada API/backend — semua data dummy dari local data source.

## Stack

- Clean Architecture feature-first: `lib/features/<feature>/{data,domain,presentation}` + `<feature>_injection.dart`
- Cubit (`flutter_bloc`) · GetIt (`sl`) · go_router · easy_localization · flutter_screenutil · dartz `Either` + `safeCall`
- Data: `*_local_data_source.dart` (dummy inline / JSON `assets/dummy/`). **Tidak ada Dio / HTTP.**
- Scaffold feature: `mason make feature --feature_name <x> --entity_name <X>`
- Run: `fvm flutter run --flavor dev -t lib/main_dev.dart` (Android) · macOS/iOS tanpa `--flavor`
- Cek: `fvm flutter analyze` · `fvm flutter test`

## Perintah slicing

- `review <folder>` (mis. `review 01-auth_sign_in`) → skill **slicing-review**: rencana + pertanyaan, tanpa kode.
- `mulai` → skill **slicing-mulai**: kerjakan sesuai `figma-code/<folder>/review.md` + jawaban user.
- Input per layar: `figma-code/NN-<screen_slug>/`; spec komponen: `figma-code/_components/<name>/` (lihat `figma-code/README.md`).

## Slicing — aturan wajib

@docs/ui/SLICING_RULES.md

Referensi yang wajib dibaca sebelum menulis UI:
- @docs/ui/COMPONENTS.md
- `docs/ui/SCREENS.md` (daftar layar + node ID)
