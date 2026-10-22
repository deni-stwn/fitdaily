import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

/// Figma *Graph · Line* (`604:11760`; used in Fitness Condition 683:54496
/// and VO₂ Max 683:54551): 207 high plot with dashed grid (`chartGrid`,
/// dash 4/4) at 100/80/60/40/20, dashed bottom + right border, Y labels
/// (8px, tertiary) on the right (x 370 of 384), a white 4px reference line,
/// a 4px [color] polyline and 8px dots (`bg` fill, 1px [color] ring).
/// X labels (spaceBetween, plot width) 8 below.
class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.points,
    required this.xLabels,
    this.yLabels = const ['100', '80', '60', '40', '20', '0'],
    this.maxY = 100,
    this.color = AppColors.blue700,
    this.referenceValue,
    this.referenceStart = 0,
  });

  /// x: 0–1 of the plot width, y: 0–[maxY].
  final List<({double x, double y})> points;
  final List<String> xLabels;
  final List<String> yLabels;
  final double maxY;
  final Color color;

  /// White reference line (null → hidden), from [referenceStart] (0–1) to
  /// the right edge.
  final double? referenceValue;
  final double referenceStart;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.bodySmall.copyWith(
      fontSize: 8.sp, // figma: 8 / Regular / 100% (no text style)
      height: 1,
      letterSpacing: 0,
      color: AppColors.textTertiary,
    );
    // figma: plot 361 · gap 9 · labels 14 (of 384).
    final axisWidth = 23.w;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.h,
      children: [
        SizedBox(
          height: 207.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CustomPaint(
                  painter: _LineChartPainter(
                    points: points,
                    maxY: maxY,
                    color: color,
                    referenceValue: referenceValue,
                    referenceStart: referenceStart,
                  ),
                ),
              ),
              SizedBox(width: axisWidth - 14.w),
              SizedBox(
                width: 14.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final l in yLabels)
                      Text(l, style: labelStyle, maxLines: 1, softWrap: false),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [for (final l in xLabels) Text(l, style: labelStyle)],
              ),
            ),
            SizedBox(width: axisWidth),
          ],
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.points,
    required this.maxY,
    required this.color,
    required this.referenceValue,
    required this.referenceStart,
  });

  final List<({double x, double y})> points;
  final double maxY;
  final Color color;
  final double? referenceValue;
  final double referenceStart;

  // Figma geometry (plot 361 × 207): 100 at y 4, 0 at y 204, border at 207.
  static const _w = 361.0;
  static const _h = 207.0;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / _w;
    final sy = size.height / _h;
    double yOf(double v) => (4 + (1 - v / maxY) * 200) * sy;

    final grid = Paint()
      ..color = AppColors.chartGrid
      ..strokeWidth = 1;
    for (final y in [4.0, 44.0, 84.0, 124.0, 164.0]) {
      _dashed(canvas, Offset(0, y * sy), Offset(size.width, y * sy), grid);
    }
    // "Vector 55": bottom + right border.
    _dashed(canvas, Offset(0, _h * sy), Offset(size.width, _h * sy), grid);
    _dashed(
      canvas,
      Offset(size.width, 3 * sy),
      Offset(size.width, _h * sy),
      grid,
    );

    if (referenceValue != null) {
      final y = yOf(referenceValue!);
      canvas.drawRRect(
        RRect.fromLTRBR(
          referenceStart * size.width,
          y - 2 * sy,
          size.width - 2 * sx,
          y + 2 * sy,
          const Radius.circular(999),
        ),
        Paint()..color = AppColors.white,
      );
    }

    if (points.isEmpty) return;
    final offsets = [
      for (final p in points) Offset(p.x * size.width, yOf(p.y)),
    ];
    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (final o in offsets.skip(1)) {
      path.lineTo(o.dx, o.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * sx
        ..strokeJoin = StrokeJoin.miter, // figma: sharp peaks
    );

    final dotFill = Paint()..color = AppColors.bg;
    final dotRing = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * sx;
    for (final o in offsets) {
      canvas.drawCircle(o, 4 * sx, dotFill);
      canvas.drawCircle(o, 3.5 * sx, dotRing); // stroke inside
    }
  }

  void _dashed(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 4.0;
    final length = (b - a).distance;
    final dir = (b - a) / length;
    for (var d = 0.0; d < length; d += dash * 2) {
      final end = (d + dash).clamp(0, length).toDouble();
      canvas.drawLine(a + dir * d, a + dir * end, paint);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.points != points ||
      old.color != color ||
      old.referenceValue != referenceValue ||
      old.referenceStart != referenceStart ||
      old.maxY != maxY;
}
