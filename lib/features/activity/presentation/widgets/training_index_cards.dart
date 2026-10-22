import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/charts/level_scale_bar.dart';
import '../../../../shared/widgets/charts/line_chart.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/overview_card_header.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/value_unit.dart';
import '../../domain/entities/training_index.dart';

/// Colour (legend dot / bar segment) and label of each level.
extension TrainingLevelX on TrainingLevel {
  Color get color => switch (this) {
    TrainingLevel.veryPoor => AppColors.zoneLight,
    TrainingLevel.poor => AppColors.zoneIntensive,
    TrainingLevel.fair => AppColors.zoneAerobic,
    TrainingLevel.normal => AppColors.zoneAnaerobic,
    TrainingLevel.good => AppColors.bgDanger,
    TrainingLevel.veryGood => AppColors.red800,
    TrainingLevel.superior => AppColors.red900,
  };

  /// Bar segment colour — VO₂ Max "Superior" segment differs from its dot.
  Color get barColor =>
      this == TrainingLevel.superior ? AppColors.scaleSuperiorBar : color;

  String get labelKey => switch (this) {
    TrainingLevel.veryPoor => LocaleKeys.training_index_level_very_poor,
    TrainingLevel.poor => LocaleKeys.training_index_level_poor,
    TrainingLevel.fair => LocaleKeys.training_index_level_fair,
    TrainingLevel.normal => LocaleKeys.training_index_level_normal,
    TrainingLevel.good => LocaleKeys.training_index_level_good,
    TrainingLevel.veryGood => LocaleKeys.training_index_level_very_good,
    TrainingLevel.superior => LocaleKeys.training_index_level_superior,
  };
}

/// "Heart rate" card (Figma *Card* 4322 / 4933): header · gap 16 · values
/// (spaceBetween) · gap 16 · [LineChart].
class TrainingIndexChartCard extends StatelessWidget {
  const TrainingIndexChartCard({super.key, required this.overview});

  final TrainingIndexOverview overview;

  @override
  Widget build(BuildContext context) {
    final o = overview;
    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3.h,
        children: [
          OverviewCardHeader(
            title: LocaleKeys.stats_heart_rate.tr(context: context),
            subtitle: LocaleKeys.stats_heart_rate_subtitle.tr(context: context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueUnit(value: o.value, unit: o.unit),
              if (o.rangeValue != null)
                ValueUnit(value: o.rangeValue!, unit: o.rangeUnit ?? '')
              else if (o.date != null)
                Text(
                  o.date!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
          LineChart(
            points: [for (final p in o.points) (x: p.x, y: p.y)],
            xLabels: o.xLabels,
            referenceValue: o.referenceValue,
            referenceStart: o.referenceStart,
          ),
        ],
      ),
    );
  }
}

/// Level card (Figma *Card* 4390 "Interpretation and Recommendation" /
/// 5000 "Weekly Summary"): header (icon 24, no button) · gap 16 · score row
/// · gap 16 · [LevelScaleBar] · gap 24 · explanation (gap 8).
class TrainingIndexLevelCard extends StatelessWidget {
  const TrainingIndexLevelCard({
    super.key,
    required this.overview,
    required this.icon,
    required this.title,
    this.legendLayout = LevelScaleLegendLayout.spread,
  });

  final TrainingIndexOverview overview;
  final String icon;
  final String title;
  final LevelScaleLegendLayout legendLayout;

  @override
  Widget build(BuildContext context) {
    final o = overview;
    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3.h,
        children: [
          SectionHeader(
            icon: icon,
            title: title,
            trailing: const SizedBox.shrink(), // figma: button hidden
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s4.h,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.s3.h,
                children: [
                  _ScoreRow(overview: o),
                  LevelScaleBar(
                    segments: [for (final s in o.segments) s.barColor],
                    marker: o.marker,
                    legendLayout: legendLayout,
                    legend: [
                      for (final l in o.legend)
                        (
                          color: l.color,
                          label: l.labelKey.tr(context: context),
                        ),
                    ],
                  ),
                ],
              ),
              if (o.explanation != null || o.recommendation != null)
                _Explanation(overview: o),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Score Row": title (`headingMedium`) / gap 4 / caption (tertiary) and,
/// on VO₂ Max, value + unit in the right half (gap 24).
class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.overview});

  final TrainingIndexOverview overview;

  @override
  Widget build(BuildContext context) {
    final o = overview;
    return Row(
      spacing: AppSpacing.s4.w,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s1.h,
            children: [
              Text(o.levelTitle, style: AppTextStyles.headingMedium),
              Text(
                o.levelCaption,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        if (o.levelValue != null)
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ValueUnit(value: o.levelValue!, unit: o.levelUnit ?? ''),
            ),
          ),
      ],
    );
  }
}

/// "Explanation Container": label in white, text in `textSecondary`.
/// Explanation 12/16 Medium (0.5), Recommendation 12/100% Regular (0).
class _Explanation extends StatelessWidget {
  const _Explanation({required this.overview});

  final TrainingIndexOverview overview;

  @override
  Widget build(BuildContext context) {
    final explanationStyle = AppTextStyles.bodySmallStrong;
    final adviceStyle = AppTextStyles.bodySmall.copyWith(
      height: 1, // figma: line height 100%
      letterSpacing: 0,
    );
    TextSpan span(String label, String? text, TextStyle style) => TextSpan(
      style: style,
      children: [
        TextSpan(text: '${label.tr(context: context)} '),
        TextSpan(
          text: text ?? '',
          style: style.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s2.h,
      children: [
        if (overview.explanation != null)
          Text.rich(
            span(
              LocaleKeys.training_index_explanation,
              overview.explanation,
              explanationStyle,
            ),
          ),
        if (overview.recommendation != null)
          Text.rich(
            span(
              LocaleKeys.training_index_recommendation,
              overview.recommendation,
              adviceStyle,
            ),
          ),
      ],
    );
  }
}
