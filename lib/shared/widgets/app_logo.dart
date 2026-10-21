import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_fonts.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';

enum AppLogoSize {
  /// Onboarding / Sign In (figma: 683:53078).
  regular,

  /// Splash Screen (figma: 683:53900).
  large,
}

/// FitDaily logo: mark (`assets/images/logo_mark.svg`) + wordmark.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = AppLogoSize.regular});

  final AppLogoSize size;

  static const _markAsset = 'assets/images/logo_mark.svg';

  @override
  Widget build(BuildContext context) {
    final (markWidth, markHeight, gap, textStyle) = switch (size) {
      AppLogoSize.regular => (42.18, 32.90, 8.83, AppTextStyles.headingMedium),
      // figma: wordmark 51.76 / h1.5 / w500 / ls -2.83 (no text token)
      AppLogoSize.large => (
        77.23,
        60.25,
        16.17,
        TextStyle(
          fontFamily: AppFonts.instrumentSans,
          fontSize: 51.76.sp,
          height: 1.5,
          letterSpacing: -2.83,
          fontWeight: FontWeight.w500,
          fontVariations: const [FontVariation.weight(500)],
          color: AppColors.text,
        ),
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fixed aspect ratio → both sides scale with width.
        SvgPicture.asset(_markAsset, width: markWidth.w, height: markHeight.w),
        SizedBox(width: gap.w),
        Text(AppStrings.appName, style: textStyle),
      ],
    );
  }
}
