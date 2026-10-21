---
name: slicing-review
description: Review a Figma export folder before slicing it into Flutter. Use when the user says "review <folder>" (e.g. "review 01-auth_sign_in", "riview 03-home"), or asks to check/analyze a screen in figma-code/ before building. Produces a plan + confirmation questions; never writes app code.
argument-hint: <folder di figma-code, contoh 01-auth_sign_in>
---

# Slicing Review

Phase 1 of the slicing flow: **review → user answers → "mulai"** (see `slicing-mulai`).
In this phase you **do not write or edit any code under `lib/`**. The only file you write is `review.md`.

## 1. Locate inputs

- Folder: `figma-code/<arg>/`. Match loosely (`01`, `auth_sign_in`, `sign in` → `01-auth_sign_in`). If ambiguous or missing, list the folders in `figma-code/` and ask.
- Read, in this order:
  1. `docs/ui/SLICING_RULES.md`
  2. `docs/ui/COMPONENTS.md`
  3. `docs/ui/SCREENS.md` (find the screen row → node ID + target feature)
  4. Everything in the folder: `screenshot.png` (view it), `spec.html` / `spec.css` / `spec.txt` / `spec_flutter.dart`, `notes.md`, list of `assets/`
  5. Specs for components this screen uses, in `figma-code/_components/<name>/` (if present)
- Look at existing code that may already cover parts of the screen: `lib/shared/widgets/`, `lib/features/<feature>/`, `lib/config/theme/`.

## 2. Check completeness

Report missing inputs explicitly (do not guess around them):
- no screenshot → cannot review, stop and ask
- no spec (only a screenshot) → say numbers cannot be taken exactly; ask the user to add `spec.html` (plugin "Figma to Code") before "mulai"
- assets visible in the screenshot but not in `assets/` → list them by layer name
- component used for the first time but no `_components/<name>/` export → note whether you can build it from this screen alone (only the variants visible) or need the full component export

## 3. Analyze

Break the screen into sections top → bottom. For each element decide:
- **Reuse** — matches a ✅ component in `COMPONENTS.md` (say which widget + props/variant)
- **New shared component** — Figma component instance not built yet (⬜) → will be built in `lib/shared/widgets/` with all known variants
- **Screen-specific widget** — only used here → `lib/features/<feature>/presentation/widgets/`
- **Asset** — which file in `assets/` goes where

Also extract:
- Values from the spec that **match tokens** (`AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`) and values that **do not** (list them with the exact number; propose a new token if used ≥ 2×)
- Layout approach (scroll? fixed bottom? overlapping glow/illustration needing `Stack`?)
- Effects that Flutter can only approximate (inner shadow, blur) — say how you plan to approximate
- Code plan: feature folder (Mason or existing), page/widget files, route name + path, dummy data (if any), localization keys

## 4. Questions

Ask only what the design cannot answer, numbered, each with your **default suggestion** so the user can reply "ikut saran" — e.g.:
- navigation targets of buttons/links
- interactive states not shown (pressed, error, loading, empty)
- validation rules, default values (checkbox checked?)
- behavior on small screens (scroll vs. fixed)
- anything ambiguous between screenshot and spec

## 5. Write `review.md` and stop

Write `figma-code/<folder>/review.md` (overwrite if re-reviewing) with this structure:

```markdown
# Review — <folder>
Status: REVIEWED (menunggu jawaban)
Screen: <name> · node `<id>` · feature `<feature>`

## Kelengkapan input
## Struktur layar
## Komponen (reuse / baru / khusus layar)
## Aset
## Token (cocok / di luar token)
## Rencana file
## Pertanyaan
1. … — saran: …
## Jawaban
_(diisi setelah user menjawab)_
```

Then reply to the user with a short summary of the review (sections, reuse/new components, missing inputs) and the numbered questions. End with: **"Jawab pertanyaannya (atau 'ikut saran'), lalu ketik `mulai`."**
Do not start implementing, even if the answers seem obvious.
