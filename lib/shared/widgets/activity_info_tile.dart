import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import 'value_unit.dart';

/// Figma *Activity Info* (`644:25769`; Running · Cycling · Walking ·
/// Exercise — variants differ only in icon/data): `bgSecondary` box,
/// radius 16, padding 16 · icon 24 in a 48 `bg` circle · gap 10 · title
/// (`bodyMedium`) / gap 8 / stats separated by 4px dots (gap 8) ··· value
/// (`headingMedium`) + unit, bottom aligned. [value] null → no distance
/// (Training History "Exercise").
class ActivityInfoTile extends StatelessWidget {
  const ActivityInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.stats,
    this.value,
    this.unit,
    this.onTap,
    this.onLongPress,
  });

  /// Asset path (24, coloured).
  final String icon;
  final String title;

  /// e.g. ["40m 15s", "3400 cal", "10 July"].
  final List<String> stats;
  final String? value;
  final String? unit;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final statStyle = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textStat,
    );
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.s3.w),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(AppRadius.large.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.bg,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(icon, width: 24.w, height: 24.w),
            ),
            SizedBox(width: 10.w), // figma: gap 10
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s2.h,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium),
                  Row(
                    spacing: AppSpacing.s2.w,
                    children: [
                      for (final (i, s) in stats.indexed) ...[
                        if (i > 0)
                          Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: const BoxDecoration(
                              color: AppColors.dotDivider,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(s, style: statStyle),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (value != null) ...[
              SizedBox(width: 10.w), // figma: gap 10
              ValueUnit(
                value: value!,
                unit: unit ?? '',
                unitColor: AppColors.textUnit,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
