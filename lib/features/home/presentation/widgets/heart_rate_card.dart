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
import '../../../../shared/widgets/charts/heart_zone_breakdown.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/value_unit.dart';
import '../../domain/entities/home_dashboard.dart';

/// Home "Heart rate" card (figma: 683:53154).
class HeartRateCard extends StatelessWidget {
  const HeartRateCard({super.key, required this.summary, this.onFullReport});

  final HeartRateSummary summary;
  final VoidCallback? onFullReport;

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
                  ValueUnit(value: '${summary.current}', unit: bpm),
                  ValueUnit(value: '${summary.min}-${summary.max}', unit: bpm),
                ],
              ),
              CandleChart(
                color: AppColors.iconDanger,
                bars: [
                  for (final b in summary.bars)
                    (left: b.left, top: b.top, height: b.height),
                ],
              ),
              HeartZoneBreakdown(zones: summary.zones),
            ],
          ),
        ],
      ),
    );
  }
}
