import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../domain/entities/metric_overview.dart';

/// Step Overview history item: `bgSecondary`, radius 16, padding 16 —
/// [48 circle `bg` + icon 24 · value (`headingMedium`) / caption] ··· date.
class HistoryTile extends StatelessWidget {
  const HistoryTile({super.key, required this.item, required this.icon});

  final OverviewHistory item;

  /// Asset path of the metric icon.
  final String icon;

  @override
  Widget build(BuildContext context) {
    final tertiary = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textTertiary,
    );
    return Container(
      padding: EdgeInsets.all(AppSpacing.s3.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(AppRadius.large.r),
      ),
      child: Row(
        spacing: AppSpacing.s3.w,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s1.h,
              children: [
                Text(item.value, style: AppTextStyles.headingMedium),
                Text(item.caption, style: tertiary),
              ],
            ),
          ),
          Text(item.date, style: tertiary),
        ],
      ),
    );
  }
}
