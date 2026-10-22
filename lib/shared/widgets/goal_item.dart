import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma *Goal Item* (`667:38565`, Default · Selected), as used on
/// "Goals - Create Goals" (683:53393):
/// - icon in a 48 `bg` circle (padding 12) · 10 · title (`bodyMedium`) over
///   description (12 Medium `textTertiary`), gap 8; padding 16, radius 16.
/// - *Default*: `bgTertiary`, fixed 84 high.
/// - *Selected*: `bgSecondary`, hugs (80 high), green check circle trailing.
class GoalItem extends StatelessWidget {
  const GoalItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.selected = false,
    this.onTap,
  });

  /// 24×24 coloured icon (asset path).
  final String icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      spacing: 10.w, // figma: 10
      children: [
        Container(
          padding: EdgeInsets.all(12.w), // figma: 12
          decoration: const BoxDecoration(
            color: AppColors.bg,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(icon, width: 24.w, height: 24.w),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s2.h,
            children: [
              Text(title, style: AppTextStyles.bodyMedium),
              Text(
                description,
                style: AppTextStyles.bodySmallStrong.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        if (selected)
          SvgPicture.asset(
            'assets/icons/goal_check.svg',
            width: 24.w,
            height: 24.w,
          ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // Selected hugs (16 + 48 + 16 = 80); Default is fixed 84.
        height: selected ? null : 84.h,
        padding: EdgeInsets.all(AppSpacing.s3.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.bgSecondary : AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(AppRadius.large.r),
        ),
        child: content,
      ),
    );
  }
}
