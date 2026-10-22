import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../domain/entities/metric_overview.dart';

/// Step Overview stats row item: icon 24 · gap 8 · value (`headingSmall`,
/// figma 20/600/1.2) · unit (`bodySmall` tertiary).
class StatItem extends StatelessWidget {
  const StatItem({super.key, required this.stat});

  final OverviewStat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.s2.h,
      children: [
        SvgPicture.asset(stat.icon, width: 24.w, height: 24.w),
        Column(
          children: [
            Text(stat.value, style: AppTextStyles.headingSmall),
            Text(
              stat.unit,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
