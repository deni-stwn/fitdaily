import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/brand_effects.dart';

/// Figma "Progress Container" (683:53318): 72-high pill (`bgSecondary`,
/// diagonal `#444` hatch exported as `progress_hatch.svg`) with a brand
/// gradient fill (Button Effect), then a 24-high label row: "0%" · current
/// (centred near the fill end) · "100%". Bar + fill have a 1px diagonal
/// white 20% → 5% stroke.
class GoalsProgressBar extends StatelessWidget {
  const GoalsProgressBar({
    super.key,
    required this.percent,
    required this.fill,
  });

  /// Label of the current value ("67%").
  final int percent;

  /// Filled fraction of the bar (0–1).
  final double fill;

  static const _height = 72.0;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.bodyLargeStrong;
    final radius = BorderRadius.circular(999);
    return LayoutBuilder(
      builder: (context, constraints) {
        final fillWidth = constraints.maxWidth * fill.clamp(0.0, 1.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s1.h,
          children: [
            SizedBox(
              height: _height.h,
              child: ClipRRect(
                borderRadius: radius,
                child: CustomPaint(
                  foregroundPainter: _GradientStrokePainter(radius),
                  child: ColoredBox(
                    color: AppColors.bgSecondary,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // figma: "Progress Indicator" group at (-78, -13);
                        // the SVG export adds a 4px margin.
                        Positioned(
                          left: -82.w,
                          top: -17.h,
                          width: 587.w,
                          height: 107.h,
                          child: SvgPicture.asset(
                            'assets/icons/progress_hatch.svg',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: fillWidth,
                          child: _Fill(radius: radius),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 24.h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 9.w, // figma
                    top: 4.h,
                    child: Text('0%', style: labelStyle),
                  ),
                  Positioned(
                    // figma: label box at x 194 for a fill ending at 220.
                    left: fillWidth - 26.w,
                    top: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s2.w,
                        vertical: AppSpacing.s1.h,
                      ),
                      child: Text('$percent%', style: labelStyle),
                    ),
                  ),
                  Positioned(
                    right: 9.w, // figma: 424 - 375 - 40
                    top: 4.h,
                    child: Text('100%', style: labelStyle),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Fill extends StatelessWidget {
  const _Fill({required this.radius});

  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _GradientStrokePainter(radius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: const LinearGradient(
            colors: [AppColors.bgBrand, AppColors.violet600],
          ),
        ),
        child: CustomPaint(
          painter: InnerShadowPainter(
            color: null,
            border: null,
            radius: radius,
            shadows: buttonEffect,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

/// 1px stroke, white 20% (top-left) → 5% (bottom-right).
class _GradientStrokePainter extends CustomPainter {
  const _GradientStrokePainter(this.radius);

  final BorderRadius radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.goalStroke, AppColors.white100],
      ).createShader(rect);
    canvas.drawRRect(radius.toRRect(rect).deflate(0.5), paint);
  }

  @override
  bool shouldRepaint(_GradientStrokePainter oldDelegate) =>
      oldDelegate.radius != radius;
}
