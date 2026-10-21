import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Bottom form card (auth, user setup): `bgSecondary`, radius 24, 1px
/// outside border, padding 24, gap 24; title `display` + optional subtitle.
class FormCard extends StatelessWidget {
  const FormCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  final String title;

  /// Optional `bodyMedium` `textTertiary` text 8 below the title.
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s4.w,
        vertical: AppSpacing.s4.h,
      ),
      decoration: ShapeDecoration(
        color: AppColors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xLarge.r),
          side: const BorderSide(
            color: AppColors.borderCard,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s4.h,
        children: [
          if (subtitle == null)
            Text(title, style: AppTextStyles.display)
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2.h,
              children: [
                Text(title, style: AppTextStyles.display),
                Text(
                  subtitle!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ...children,
        ],
      ),
    );
  }
}
