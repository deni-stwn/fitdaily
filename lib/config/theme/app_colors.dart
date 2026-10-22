import 'package:flutter/material.dart';

/// Color tokens from Figma "Fitdaily (Product)" variables.
/// Names mirror the Figma variable names (`--color-bg-secondary` → [bgSecondary]).
/// Never hardcode hex values in widgets — add the token here first.
class AppColors {
  AppColors._();

  // ── Background ─────────────────────────────────────────────── --color-bg-*
  static const Color bg = Color(0xFF1E1E1E);
  static const Color bgSecondary = Color(0xFF2C2C2C);
  static const Color bgTertiary = Color(0xFF383838);
  static const Color bgBrand = Color(0xFF5B23FF);
  static const Color bgSelected = Color(0xFF4E4D75);
  static const Color bgDisabled = Color(0xFF757575);
  static const Color bgDisabledSecondary = Color(0xFFB3B3B3);
  static const Color bgSuccess = Color(0xFF198F51);
  static const Color bgSuccessTertiary = Color(0xFF476656);
  static const Color bgWarningTertiary = Color(0xFF5C4100);
  static const Color bgDanger = Color(0xFFE03E1A);
  static const Color bgDangerTertiary = Color(0xFF60332A);

  // ── Gradients (no Figma variable) ─────────────────────────────────────────
  static const Color splashGradientEnd = Color(0xFF120A2F); // figma: 683:53900
  // Blurred Effect · full (Setting panel 683:54836): #262626 @20%, no variable.
  static const Color blurOverlay = Color(0x33262626);

  // ── Heart-rate zones & charts (Home, no variable) ─────────────────────────
  static const Color zoneLight = Color(0xFF4171B0);
  static const Color zoneIntensive = Color(0xFF21BFB7);
  static const Color zoneAerobic = Color(0xFF61C160);
  static const Color zoneAnaerobic = Color(0xFFFF9A00);
  static const Color zoneVo2Max = iconDanger;
  // Training Index (683:54496 / 683:54551) — no variable.
  static const Color chartGrid = Color(0xFF353535); // Graph Line grid
  static const Color scaleSuperiorBar = Color(
    0xFF412621,
  ); // VO₂ Max bar segment 7 (legend "Superior" uses red900)
  static const Color scrim = Color(
    0x99262626,
  ); // Blurred Effect · full (#262626 60%)
  static const Color lime700 = Color(
    0xFF97B800,
  ); // --ramp-lime-700 (Moving Time)

  // ── Training map (Activity training flow 683:53476…, no variable) ───────
  static const Color mapRoute = Color(0xFF71B44C); // route line + start dot
  static const Color mapRouteDot = Color(0xFFF6F3F2); // start dot centre
  static const Color overlayScrim = Color(
    0xFF262626,
  ); // "Blurred Effect" full (60% sheet / 20% finish), no variable

  // Goals bar charts (683:53318 "Bar fill") — no variable.
  static const Color goalBar = Color(0xFFFF3D00);
  // Goals progress bar stroke (white 20% → 5%) and Create Goal sheet scrim
  // (683:53393 "Blurred Effect" #262626 @20%) — no variable.
  static const Color goalStroke = Color(0x33FFFFFF);
  static const Color sheetScrim = Color(0x33262626);

  // ── Text ───────────────────────────────────────────────────── --color-text-*
  static const Color text = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB2FFFFFF);
  static const Color textTertiary = Color(0x66FFFFFF);
  static const Color textDisabled = Color(0x66FFFFFF);
  static const Color textOnDisabled = Color(0xFF757575);
  static const Color textOnInverse = Color(0xE5000000);
  static const Color textSelected = Color(0xFFB7AEFF);
  static const Color textSuccess = Color(0xFF79D297);
  static const Color textWarning = Color(0xFFF7D15F);
  static const Color textDanger = Color(0xFFFCA397);
  static const Color textMuted = Color(
    0xFFA9A9A9,
  ); // device status, no variable
  static const Color textStat = Color(
    0xFF797979,
  ); // Activity Info stats, no variable
  static const Color textUnit = Color(
    0xFF8F8F8F,
  ); // Activity Info "km", no variable
  static const Color dotDivider = Color(
    0xFF929292,
  ); // Activity Info stat separator, no variable

  // ── Icon ───────────────────────────────────────────────────── --color-icon-*
  static const Color icon = Color(0xFFFFFFFF);
  static const Color iconSecondary = Color(0xB2FFFFFF);
  static const Color iconTertiary = Color(0x66FFFFFF);
  static const Color iconBrand = Color(0xFFB7AEFF);
  static const Color iconBrandSecondary = Color(0xFF714DFF);
  static const Color iconSelected = Color(0xFFB7AEFF);
  static const Color iconSuccess = Color(0xFF198F51);
  static const Color iconWarning = Color(0xFFF3C11B);
  static const Color iconDanger = Color(0xFFE03E1A);

  // Overview gauges (683:54172 / 683:54259) — no variable. Steps knob
  // gradient end from the spec; Calories arc/knob measured (no spec).
  static const Color gaugeSuccessDark = Color(0xFF0A4C2D);
  static const Color gaugeWarning = Color(0xFFAA7D01);
  static const Color gaugeWarningDark = Color(0xFF654800);

  // ── Border ─────────────────────────────────────────────────── --color-border-*
  static const Color border = Color(0xFF444444);
  static const Color borderDisabled = Color(0xFF444444);
  static const Color borderOnSelected = Color(0xFF6A699B);
  static const Color borderDanger = Color(0xFF963323);
  static const Color borderDefaultSecondary = Color(0xFF1E1E1E);
  static const Color borderCard = Color(0x4DFFFFFF); // auth cards, no variable

  // ── Ramps (raw palette) ────────────────────────────────────── --ramp-*
  static const Color violet100 = Color(0xFFF3F2FF);
  static const Color violet600 = Color(0xFF714DFF);
  static const Color violet700 = Color(0xFF5B23FF);
  static const Color violet1000 = Color(0xFF1F076E);
  static const Color blue700 = Color(0xFF069EFF);
  static const Color red800 = Color(0xFF7C2622);
  static const Color red900 = Color(0xFF54211C);
  static const Color white100 = Color(0x0DFFFFFF);
  static const Color white200 = Color(0x1AFFFFFF);
  static const Color white600 = Color(0xCCFFFFFF);

  // ── Basic ──────────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color divider = border;
}
