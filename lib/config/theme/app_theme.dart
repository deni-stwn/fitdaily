import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_fonts.dart';
import 'app_text_styles.dart';
import 'app_text_theme.dart';

/// Material theme built from Figma tokens. The design is dark-only, so
/// [lightTheme] aliases [darkTheme] until a light design exists.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => darkTheme;

  static ThemeData get darkTheme {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.large.r),
      borderSide: BorderSide.none,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.bgBrand,
      scaffoldBackgroundColor: AppColors.bg,
      fontFamily: AppFonts.appFontFamily,
      textTheme: AppTextTheme.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.bgBrand,
        secondary: AppColors.iconBrandSecondary,
        surface: AppColors.bgSecondary,
        surfaceContainerHighest: AppColors.bgTertiary,
        error: AppColors.bgDanger,
        onPrimary: AppColors.text,
        onSecondary: AppColors.text,
        onSurface: AppColors.text,
        onSurfaceVariant: AppColors.textSecondary,
        onError: AppColors.text,
        outline: AppColors.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.icon),
        titleTextStyle: AppTextStyles.headingSmall,
      ),
      iconTheme: const IconThemeData(color: AppColors.icon),
      cardTheme: CardThemeData(
        color: AppColors.bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xLarge.r),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgTertiary,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s3.w,
          vertical: AppSpacing.s3.h,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.borderOnSelected),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.borderDanger),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.borderDanger),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textDanger,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }
}
