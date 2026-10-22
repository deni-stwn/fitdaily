import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import 'gradient_border_card.dart';

/// Figma *Graph · Small Chart* metric card (Steps, Calories, Moving Time):
/// header (icon · title · chevron), 7 daily bars (track 8×50 `bgSecondary`,
/// fill [color] with 1.5px `bg` border), value + unit, "/goal".
class WeeklyBarCard extends StatelessWidget {
  const WeeklyBarCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.days,
    required this.dayLabels,
    required this.value,
    required this.unit,
    required this.goal,
    this.onMore,
  });

  final String icon;
  final String title;
  final Color color;

  /// Fill heights in Figma px (track 50).
  final List<double> days;
  final List<String> dayLabels;
  final String value;
  final String unit;
  final String goal;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final tertiary = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textTertiary,
    );

    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s3.h,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 24.w, height: 24.w),
              SizedBox(width: AppSpacing.s2.w),
              Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
              GestureDetector(
                onTap: onMore,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 32.w,
                  height: 32.w,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/chevron_right.svg',
                      width: 16.w,
                      height: 16.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
          WeeklyBarChart(days: days, dayLabels: dayLabels, color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2.h,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end, // figma
                spacing: AppSpacing.s1.w,
                children: [
                  Text(value, style: AppTextStyles.headingLarge),
                  Text(unit, style: tertiary),
                ],
              ),
              Text(goal, style: tertiary),
            ],
          ),
        ],
      ),
    );
  }
}

/// The 7 daily bars of *Graph · Small Chart* (track 8×50 `bgSecondary`,
/// fill [color] with 1.5px `bg` border, day label below), spread with
/// `spaceBetween` over the available width. Also used by Home
/// "Activity Overview" (165 wide).
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    super.key,
    required this.days,
    required this.dayLabels,
    required this.color,
  });

  /// Fill heights in Figma px (track 50).
  final List<double> days;
  final List<String> dayLabels;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tertiary = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textTertiary,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < days.length; i++)
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s1.h,
            children: [
              _DayBar(fill: days[i], color: color),
              // Labels are wider than the 8px column (figma: centred).
              SizedBox(
                width: 8.w,
                height: 16.h,
                child: OverflowBox(
                  maxWidth: 24.w,
                  maxHeight: 16.h,
                  child: Text(
                    dayLabels[i],
                    textAlign: TextAlign.center,
                    style: tertiary,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _DayBar extends StatelessWidget {
  const _DayBar({required this.fill, required this.color});

  final double fill;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 50.h,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        width: 8.w,
        height: fill.h,
        decoration: BoxDecoration(
          color: color,
          // figma: 1.5 `bg` stroke outside the fill.
          border: Border.all(
            color: AppColors.bg,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
