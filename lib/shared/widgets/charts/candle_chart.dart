import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

/// One bar in Figma chart coordinates (inside a 357 × 111.56 area).
typedef CandleBar = ({double left, double top, double height});

/// Figma *Graph · Candle Chart* (`641:18577`), 207 high: bars (3.72 wide,
/// pill) in a 357 × 111.56 area 4 below the top, dashed grid at the Y label
/// centres, dashed right edge, Y labels at x 370, X labels below.
/// Grid/axis lines are not in the export → measured from the screenshot.
class CandleChart extends StatelessWidget {
  const CandleChart({
    super.key,
    required this.bars,
    required this.color,
    this.yLabels = const ['100', '80', '60', '40', '20', '0'],
    this.xLabels = const ['00.00', '06.00', '12.00', '06.00', '00.00'],
  });

  final List<CandleBar> bars;
  final Color color;
  final List<String> yLabels;
  final List<String> xLabels;

  static const _height = 207.0;
  static const _plotWidth = 360.75; // up to the dashed right edge
  static const _labelHeight = 8.0;

  /// 8px axis labels (no Figma text style).
  static TextStyle get axisStyle => AppTextStyles.bodySmall.copyWith(
    fontSize: 8.sp,
    height: 1,
    letterSpacing: 0,
    color: AppColors.textTertiary,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        SizedBox(
          height: _height.h,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GridPainter(
                    rows: yLabels.length,
                    plotWidth: _plotWidth.w,
                    labelHeight: _labelHeight.h,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 4.h,
                width: 357.w,
                height: 111.56.h,
                child: CustomPaint(
                  painter: _BarsPainter(bars: bars, color: color),
                ),
              ),
              Positioned(
                left: 370.w,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final label in yLabels) Text(label, style: axisStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: _plotWidth.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in xLabels) Text(label, style: axisStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _BarsPainter extends CustomPainter {
  const _BarsPainter({required this.bars, required this.color});

  final List<CandleBar> bars;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 357;
    final sy = size.height / 111.56;
    final paint = Paint()..color = color;
    for (final bar in bars) {
      final rect = Rect.fromLTWH(
        bar.left * sx,
        bar.top * sy,
        3.72 * sx,
        bar.height * sy,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rect.width)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.bars != bars || old.color != color;
}

class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.rows,
    required this.plotWidth,
    required this.labelHeight,
  });

  final int rows;
  final double plotWidth;
  final double labelHeight;

  static const _dash = 5.0;
  static const _gap = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white200
      ..strokeWidth = 1;
    // Horizontal lines at the label centres (labels are spaced between).
    final step = (size.height - labelHeight) / (rows - 1);
    for (var i = 0; i < rows; i++) {
      final y = i == rows - 1 ? size.height - 0.5 : labelHeight / 2 + step * i;
      for (var x = 0.0; x < plotWidth; x += _dash + _gap) {
        canvas.drawLine(Offset(x, y), Offset(x + _dash, y), paint);
      }
    }
    // Dashed right edge of the plot.
    for (var y = labelHeight / 2; y < size.height; y += _dash + _gap) {
      canvas.drawLine(
        Offset(plotWidth, y),
        Offset(plotWidth, y + _dash),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.rows != rows || old.plotWidth != plotWidth;
}
