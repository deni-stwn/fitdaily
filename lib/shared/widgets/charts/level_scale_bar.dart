import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_dimens.dart';
import 'legend_item.dart';
import 'segmented_progress_bar.dart';

/// How the legend under a [LevelScaleBar] is laid out.
enum LevelScaleLegendLayout {
  /// Equal-width cells, label centred (Fitness Condition, 4 levels).
  spread,

  /// Hug items, gap 16, wrapping to a new line (VO₂ Max, 7 levels).
  wrap,
}

/// Level scale (Figma "Segmented Progress Bar" frame in Fitness Condition
/// 683:54496 / VO₂ Max 683:54551): `bgSecondary` track (pad 1, radius
/// full) with equal 8px [SegmentedProgressBar] segments (gap 2), a 14×8
/// triangle marker (white 70%) overlapping the bar top at [marker] (0–1),
/// then gap 16 and a [LegendItem] (dot + label) per level.
class LevelScaleBar extends StatelessWidget {
  const LevelScaleBar({
    super.key,
    required this.segments,
    required this.marker,
    required this.legend,
    this.legendLayout = LevelScaleLegendLayout.spread,
  });

  final List<Color> segments;

  /// Triangle centre, 0–1 of the bar width.
  final double marker;
  final List<({Color color, String label})> legend;
  final LevelScaleLegendLayout legendLayout;

  @override
  Widget build(BuildContext context) {
    final items = [
      for (final l in legend) LegendItem(color: l.color, label: l.label),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s3.h,
      children: [
        LayoutBuilder(
          builder: (context, box) => Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(1), // figma: pad 1
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: SegmentedProgressBar(
                  height: 8,
                  segments: [for (final c in segments) (width: 1, color: c)],
                ),
              ),
              // figma: "Polygon 1" 14×8, rotated 180°, top −4.
              Positioned(
                left: marker * box.maxWidth - 7.w,
                top: -4.h,
                child: CustomPaint(
                  size: Size(14.w, 8.h),
                  painter: _TrianglePainter(),
                ),
              ),
            ],
          ),
        ),
        switch (legendLayout) {
          LevelScaleLegendLayout.spread => Row(
            spacing: AppSpacing.s3.w,
            children: [
              for (final i in items) Expanded(child: Center(child: i)),
            ],
          ),
          LevelScaleLegendLayout.wrap => Wrap(
            spacing: AppSpacing.s3.w,
            children: items,
          ),
        },
      ],
    );
  }
}

/// Downward triangle, white 70% (`textSecondary`).
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
