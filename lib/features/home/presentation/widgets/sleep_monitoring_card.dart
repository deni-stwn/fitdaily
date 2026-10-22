import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/entities/home_dashboard.dart';

/// Home "Sleep Monitoring" card (figma: 10994 in Home 683:53154): header with
/// "See Full Activity", duration "7h39m" bottom-left and the sleep-stage
/// step chart (248×88) on the right.
class SleepMonitoringCard extends StatelessWidget {
  const SleepMonitoringCard({super.key, required this.sleep, this.onSeeAll});

  final SleepSummary sleep;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    // figma: 32 / Medium / line height 100% (no text style)
    final number = AppTextStyles.headingLarge.copyWith(
      height: 1,
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
      fontVariations: const [FontVariation.weight(500)],
    );
    final unit = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textTertiary,
    );

    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s3.h,
        children: [
          SectionHeader(
            icon: 'assets/icons/metric_sleep.svg',
            title: LocaleKeys.home_sleep_monitoring.tr(context: context),
            actionLabel: LocaleKeys.home_see_full_activity.tr(context: context),
            actionChevron: false,
            actionColor: AppColors.textSecondary,
            onAction: onSeeAll,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end, // figma: max
            children: [
              SizedBox(
                width: 102.w, // figma: Time Container fixed width
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end, // figma: max
                  children: [
                    Text('${sleep.hours}', style: number),
                    Text(
                      LocaleKeys.home_hour_unit.tr(context: context),
                      style: unit,
                    ),
                    Text('${sleep.minutes}', style: number),
                    Text(
                      LocaleKeys.home_minute_unit.tr(context: context),
                      style: unit,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 248.w,
                height: 88.h,
                child: CustomPaint(
                  painter: _SleepStagePainter(
                    stages: sleep.stages,
                    scaleX: 1.w,
                    scaleY: 1.h,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Figma "Graph Container": a thin `iconBrandSecondary` 20% step line
/// ("Line indicator", 1px) under thick 7px segments ("Indicator") per
/// stage. Levels 0…3 sit at y -14, 20, 54, 88 (34 apart, top one above the
/// box like in Figma). The thin line runs through the segment centres.
class _SleepStagePainter extends CustomPainter {
  _SleepStagePainter({
    required this.stages,
    required this.scaleX,
    required this.scaleY,
  });

  final List<SleepStage> stages;
  final double scaleX;
  final double scaleY;

  static const _top = -14.0; // figma: Vector 14 y
  static const _step = 34.0; // figma: 20 - (-14), 54 - 20, 88 - 54

  double _y(int level) => (_top + level * _step) * scaleY;

  @override
  void paint(Canvas canvas, Size size) {
    if (stages.isEmpty) return;

    final line = Path()
      ..moveTo(stages.first.x * scaleX, _y(stages.first.level));
    for (final s in stages) {
      line
        ..lineTo(s.x * scaleX, _y(s.level))
        ..lineTo((s.x + s.width) * scaleX, _y(s.level));
    }
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.iconBrandSecondary.withValues(alpha: 0.2),
    );

    final bold = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          7 *
          scaleY // figma: strokeWeight 7
      ..color = AppColors.iconBrandSecondary;
    for (final s in stages) {
      canvas.drawLine(
        Offset(s.x * scaleX, _y(s.level)),
        Offset((s.x + s.width) * scaleX, _y(s.level)),
        bold,
      );
    }
  }

  @override
  bool shouldRepaint(_SleepStagePainter old) =>
      old.stages != stages || old.scaleX != scaleX || old.scaleY != scaleY;
}
