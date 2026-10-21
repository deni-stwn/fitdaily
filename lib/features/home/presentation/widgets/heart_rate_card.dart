import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/charts/candle_chart.dart';
import '../../../../shared/widgets/charts/legend_item.dart';
import '../../../../shared/widgets/charts/segmented_progress_bar.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../domain/entities/home_dashboard.dart';

/// Home "Heart rate" card (figma: 683:53154).
class HeartRateCard extends StatelessWidget {
  const HeartRateCard({super.key, required this.summary, this.onFullReport});

  final HeartRateSummary summary;
  final VoidCallback? onFullReport;

  static Color zoneColor(HeartZoneType type) => switch (type) {
    HeartZoneType.light => AppColors.zoneLight,
    HeartZoneType.intensive => AppColors.zoneIntensive,
    HeartZoneType.aerobic => AppColors.zoneAerobic,
    HeartZoneType.anaerobic => AppColors.zoneAnaerobic,
    HeartZoneType.vo2max => AppColors.zoneVo2Max,
  };

  static String zoneLabelKey(HeartZoneType type) => switch (type) {
    HeartZoneType.light => LocaleKeys.home_zone_light,
    HeartZoneType.intensive => LocaleKeys.home_zone_intensive,
    HeartZoneType.aerobic => LocaleKeys.home_zone_aerobic,
    HeartZoneType.anaerobic => LocaleKeys.home_zone_anaerobic,
    HeartZoneType.vo2max => LocaleKeys.home_zone_vo2max,
  };

  @override
  Widget build(BuildContext context) {
    final bpm = LocaleKeys.home_bpm.tr(context: context);

    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s3.h,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/metric_heart_rate.svg',
                width: 24.w,
                height: 24.w,
              ),
              SizedBox(width: AppSpacing.s2.w),
              Expanded(
                child: Text(
                  LocaleKeys.home_heart_rate.tr(context: context),
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              AppButton(
                label: LocaleKeys.home_full_report.tr(context: context),
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.small,
                onPressed: onFullReport,
              ),
            ],
          ),
          Column(
            spacing: AppSpacing.s2.h,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BpmValue(value: '${summary.current}', unit: bpm),
                  _BpmValue(value: '${summary.min}-${summary.max}', unit: bpm),
                ],
              ),
              CandleChart(
                color: AppColors.iconDanger,
                bars: [
                  for (final b in summary.bars)
                    (left: b.left, top: b.top, height: b.height),
                ],
              ),
              SegmentedProgressBar(
                segments: [
                  for (final z in summary.zones)
                    (width: z.width, color: zoneColor(z.type)),
                ],
              ),
            ],
          ),
          Row(
            spacing: AppSpacing.s3.w,
            children: [
              for (final z in summary.zones)
                Expanded(
                  child: LegendItem(
                    color: zoneColor(z.type),
                    label: zoneLabelKey(z.type).tr(context: context),
                    value: '${z.minutes}',
                    unit: LocaleKeys.home_mins.tr(context: context),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BpmValue extends StatelessWidget {
  const _BpmValue({required this.value, required this.unit});

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end, // figma
      spacing: AppSpacing.s1.w,
      children: [
        Text(value, style: AppTextStyles.headingMedium),
        Text(
          unit,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
