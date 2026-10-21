import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

/// Typography tokens from Figma text styles (`heading/*`, `body/*`, `display`).
/// The real weight (incl. Figma 450/550) comes from [FontVariation] on the
/// variable font. [FontWeight] is capped at w500: requesting w600+ makes the
/// engine add synthetic bold on top of the variation (verified visually).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _style({
    required String family,
    required double size,
    required double lineHeight,
    required double weight,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size.sp,
      height: lineHeight / size,
      letterSpacing: letterSpacing,
      fontWeight: FontWeight.values[((weight / 100).round() - 1).clamp(0, 4)],
      fontVariations: [FontVariation.weight(weight)],
      color: AppColors.text,
    );
  }

  // display — Instrument Serif 48/56, 450
  static TextStyle get display => _style(
    family: AppFonts.instrumentSerif,
    size: 48,
    lineHeight: 56,
    weight: 450,
  );

  // heading/large — 32/36, 600, -1
  static TextStyle get headingLarge => _style(
    family: AppFonts.instrumentSans,
    size: 32,
    lineHeight: 36,
    weight: 600,
    letterSpacing: -1,
  );

  // heading/medium — 24/28, 600
  static TextStyle get headingMedium => _style(
    family: AppFonts.instrumentSans,
    size: 24,
    lineHeight: 28,
    weight: 600,
  );

  // heading/small — 20/24, 600
  static TextStyle get headingSmall => _style(
    family: AppFonts.instrumentSans,
    size: 20,
    lineHeight: 24,
    weight: 600,
  );

  // body/large — 16/24, 450, -0.25
  static TextStyle get bodyLarge => _style(
    family: AppFonts.instrumentSans,
    size: 16,
    lineHeight: 24,
    weight: 450,
    letterSpacing: -0.25,
  );

  // body/large/strong — 16/24, 550, -0.25
  static TextStyle get bodyLargeStrong => _style(
    family: AppFonts.instrumentSans,
    size: 16,
    lineHeight: 24,
    weight: 550,
    letterSpacing: -0.25,
  );

  // body/medium — 14/18, 450, 0.5
  static TextStyle get bodyMedium => _style(
    family: AppFonts.instrumentSans,
    size: 14,
    lineHeight: 18,
    weight: 450,
    letterSpacing: 0.5,
  );

  // body/medium/strong — 14/18, 550, 0.5
  static TextStyle get bodyMediumStrong => _style(
    family: AppFonts.instrumentSans,
    size: 14,
    lineHeight: 18,
    weight: 550,
    letterSpacing: 0.5,
  );

  // body/small — 12/16, 400, 0.5
  static TextStyle get bodySmall => _style(
    family: AppFonts.instrumentSans,
    size: 12,
    lineHeight: 16,
    weight: 400,
    letterSpacing: 0.5,
  );

  // body/small/strong — 12/16, 550, 0.5
  static TextStyle get bodySmallStrong => _style(
    family: AppFonts.instrumentSans,
    size: 12,
    lineHeight: 16,
    weight: 550,
    letterSpacing: 0.5,
  );
}
