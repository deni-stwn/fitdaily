---
name: slicing-mulai
description: Implement a reviewed Figma screen in Flutter. Use when the user says "mulai" (or "mulai <folder>", "gas", "lanjut slicing") after a slicing review, or answers the review questions and asks to start building.
argument-hint: "[folder di figma-code — opsional, default: review terakhir]"
---

# Slicing — Mulai

Phase 2 of the flow: **review → user answers → "mulai"**.

## 1. Find the reviewed folder

- Use the argument if given; otherwise the folder reviewed most recently in this conversation;
  otherwise the `figma-code/*/review.md` with `Status: REVIEWED` that was modified last.
- No `review.md` → do not build. Tell the user to run `review <folder>` first.
- If the review listed blocking missing inputs (no spec, missing assets) that are still missing → stop and say what is still needed.

## 2. Record the answers

- Write the user's answers into the `## Jawaban` section of `review.md` (if they replied "ikut saran", copy the suggested defaults).
- If an answer changes the plan, update the plan sections first.
- Set `Status: IN PROGRESS`.

## 3. Build (follow `docs/ui/SLICING_RULES.md` strictly)

Order:
1. **New tokens** agreed in the review → `lib/config/theme/`.
2. **Assets** → copy from `figma-code/<folder>/assets/` (and `_components/*/assets/`) to `assets/icons/` or `assets/images/`; register folders in `pubspec.yaml` if new.
3. **New shared components** → `lib/shared/widgets/<name>.dart`, all known variants (enums), export in `widgets.dart`. Build from `_components/<name>/` spec when present.
4. **Feature scaffolding** → Mason (`mason make feature …`) for a new feature, or the existing feature folder. Dummy data in `*_local_data_source.dart` if the screen shows data.
5. **Screen** → `presentation/pages/<screen>_page.dart` + screen-specific widgets in `presentation/widgets/`.
6. **Route** → `route_names.dart` + `app_router.dart`; DI in `injection_container.dart` if a new feature.

Rules while building:
- Every number comes from the spec; no hardcoded hex/font sizes (tokens only).
- Reuse what the review said to reuse; don't create look-alike widgets.
- Anything not covered by the review or answers → ask, don't improvise.

## 4. Verify

- `fvm dart format` on changed files, `fvm flutter analyze` → must be clean; `fvm flutter test`.
- Re-check against `screenshot.png`: every section, text (exact copy), asset (present, right size/position), spacing, colors.
- Add the screen to `test/visual/screens_render_test.dart` and run `fvm flutter test test/visual` → `build/visual/<name>.png` (440×956 @2x, real fonts).
  Compare with the Figma screenshot (crop/zoom sections side by side); fix mismatches. Deviations you cannot resolve from the spec → report, don't guess.

## 5. Update the records

- `docs/ui/COMPONENTS.md` → status ✅/🟡, widget/file column, usage example for each new component.
- `docs/ui/SCREENS.md` → status of this screen ✅ (or 🟡 + reason) and the page widget name.
- `review.md` → `Status: DONE` + short list of files created/changed + known deviations (e.g. approximated inner shadow).

## 6. Report

Short summary: files created, components reused/created, deviations from Figma, verification results (analyze/test/visual), and the next suggested folder from `SCREENS.md`.
