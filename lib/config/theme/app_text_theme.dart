import 'package:flutter/material.dart';

import 'app_text_styles.dart';

/// Maps Figma text styles onto Material [TextTheme] slots so default widgets
/// inherit them. In custom widgets prefer [AppTextStyles] directly.
class AppTextTheme {
  static TextTheme get dark => TextTheme(
    displayLarge: AppTextStyles.display,
    headlineLarge: AppTextStyles.headingLarge,
    headlineMedium: AppTextStyles.headingMedium,
    headlineSmall: AppTextStyles.headingSmall,
    titleLarge: AppTextStyles.headingSmall,
    titleMedium: AppTextStyles.bodyLargeStrong,
    titleSmall: AppTextStyles.bodyMediumStrong,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.bodyMediumStrong,
    labelMedium: AppTextStyles.bodySmallStrong,
    labelSmall: AppTextStyles.bodySmall,
  );

  static TextTheme get light => dark;
}
