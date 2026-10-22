import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/weekly_bar_card.dart';
import '../../domain/entities/home_dashboard.dart';

/// Home "Activity Overview" card (figma: 10904 in Home 683:53154):
/// header with "See Full Activity", big percentage + "/45 Minutes" on the
/// left, 7 daily bars (165 wide, `bgBrand`) on the right, bottom aligned.
class ActivityOverviewCard extends StatelessWidget {
  const ActivityOverviewCard({
    super.key,
    required this.activity,
    required this.dayLabels,
    this.onSeeAll,
  });

  final HomeActivitySummary activity;
  final List<String> dayLabels;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s3.h,
        children: [
          SectionHeader(
            icon: 'assets/icons/metric_activity.svg',
            title: LocaleKeys.home_activity_overview.tr(context: context),
            actionLabel: LocaleKeys.home_see_full_activity.tr(context: context),
            actionChevron: false,
            actionColor: AppColors.textSecondary,
            onAction: onSeeAll,
          ),
          SizedBox(
            height: 96.5.h, // figma: Graph fixed height
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end, // figma: max
              spacing: AppSpacing.s3.w,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s2.h,
                  children: [
                    Text(
                      '${activity.percent}%',
                      // figma: 48 / Medium / line height 100% (no text style)
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 48.sp,
                        height: 1,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        fontVariations: const [FontVariation.weight(500)],
                      ),
                    ),
                    Text(
                      LocaleKeys.home_goal_minutes.tr(
                        context: context,
                        args: ['${activity.goalMinutes}'],
                      ),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 165.w, // figma: Chart fixed width
                  child: WeeklyBarChart(
                    days: activity.days,
                    dayLabels: dayLabels,
                    color: AppColors.bgBrand,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
