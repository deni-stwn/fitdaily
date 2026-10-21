import 'package:flutter/material.dart';

/// Spacing tokens from Figma `--spacer-*` variables (raw px; apply `.w/.h`).
class AppSpacing {
  AppSpacing._();

  static const double s0 = 0; // --spacer-0
  static const double s1 = 4; // --spacer-1
  static const double s2 = 8; // --spacer-2
  static const double s3 = 16; // --spacer-3
  static const double s4 = 24; // --spacer-4
}

/// Radius tokens from Figma `--radius-*` variables (raw px; apply `.r`).
/// Note: Figma's `--radius-large` resolves to 16 on some frames and 24 on
/// others — always read the node's actual value and pick [large] or [xLarge].
class AppRadius {
  AppRadius._();

  static const double medium = 8; // --radius-medium
  static const double large = 16; // --radius-large (16)
  static const double xLarge = 24; // --radius-large (24)
  static const double full = 9999; // --radius-full
}

/// Effect tokens from Figma.
class AppShadows {
  AppShadows._();

  /// Figma "Button Effect" is 3 INNER shadows, which Flutter's [BoxShadow]
  /// cannot express. Approximate with gradients/overlays inside the widget:
  /// #00000080 (-2,-2) blur 6 · #00000026 (0,32) blur 16 · #FFFFFF33 (2,2) blur 2.
  static const String buttonEffectSpec =
      'INNER #00000080 (-2,-2) r6; INNER #00000026 (0,32) r16; INNER #FFFFFF33 (2,2) r2';
}

/// Frame size of the Figma designs (iPhone 15 Pro Max). Used by ScreenUtil.
class AppDesign {
  AppDesign._();

  static const Size frameSize = Size(440, 956);
}
