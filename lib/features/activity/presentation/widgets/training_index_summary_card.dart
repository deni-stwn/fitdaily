import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../domain/entities/activity_overview.dart';
import '../../domain/entities/training_index.dart';

/// Activity "Training Index" card (Figma Card 190×151 in 683:53210).
/// The card content is NOT in the exported file (empty instance) — layout
/// measured from the design screenshot the user supplied: title
/// (`bodyMedium`) · 8 · value (`headingMedium`) · 4 · caption (`bodySmall`
/// tertiary) · 16 · gradient scale 6 high with a 10×6 marker · 8 · end
/// labels (10/400 tertiary).
class TrainingIndexSummaryCard extends StatelessWidget {
  const TrainingIndexSummaryCard({super.key, required this.item, this.onTap});

  final TrainingIndexSummary item;
  final VoidCallback? onTap;

  /// Scale colours, left → right (screenshot).
  static List<Color> _scale(TrainingIndexKind kind) => switch (kind) {
    TrainingIndexKind.fitnessCondition => const [
      AppColors.zoneLight,
      AppColors.zoneIntensive,
      AppColors.zoneAerobic,
      AppColors.iconWarning,
      AppColors.zoneAnaerobic,
    ],
    TrainingIndexKind.vo2Max => const [
      AppColors.iconBrandSecondary,
      AppColors.zoneLight,
      AppColors.zoneIntensive,
      AppColors.zoneAerobic,
      AppColors.iconWarning,
      AppColors.zoneAnaerobic,
    ],
  };

  @override
  Widget build(BuildContext context) {
    final tertiary = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textTertiary,
    );
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: GradientBorderCard(
        padding: AppSpacing.s3,
        child: SizedBox(
          height: 119.h, // figma: card 151 − padding 16 × 2
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: AppTextStyles.bodyMedium),
              SizedBox(height: AppSpacing.s2.h),
              Text(
                item.value,
                style: AppTextStyles.headingMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSpacing.s1.h),
              Text(item.caption, style: tertiary),
              const Spacer(),
              _GradientScale(colors: _scale(item.kind), marker: item.marker),
              SizedBox(height: AppSpacing.s2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // screenshot: 10px labels (no text style token).
                  Text(
                    item.minLabel,
                    style: tertiary.copyWith(fontSize: 10.sp),
                  ),
                  Text(
                    item.maxLabel,
                    style: tertiary.copyWith(fontSize: 10.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded gradient bar (6 high) with a downward triangle marker above it.
class _GradientScale extends StatelessWidget {
  const _GradientScale({required this.colors, required this.marker});

  final List<Color> colors;
  final double marker;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 6.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.full),
              gradient: LinearGradient(colors: colors),
            ),
          ),
          Positioned(
            left: marker.clamp(0, 1) * box.maxWidth - 5.w,
            top: -6.h,
            child: CustomPaint(
              size: Size(10.w, 6.h),
              painter: _TrianglePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.textSecondary);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) => false;
}
