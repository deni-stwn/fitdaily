import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

/// Overview gauge (Step/Calories Overview, 683:54172): 270° arc open at the
/// bottom (track `white100`, progress [color]), round knob at the progress
/// end (48, 4px `bg` ring, vertical gradient [knobColors], icon 24), value
/// (48/w500) + caption. The arc vectors are not in the export → centre
/// y 156.3, radius 134.5 (circle fit on the screenshot edges),
/// stroke 24 and the vertical fade (y 25 → 191) were measured from the
/// screenshots.
class ArcGauge extends StatelessWidget {
  const ArcGauge({
    super.key,
    required this.progress,
    required this.color,
    required this.knobColors,
    required this.knobIcon,
    required this.value,
    required this.caption,
    this.height = 212.5,
    this.offsetY = 0,
  });

  /// 0..1 of the 270° arc.
  final double progress;
  final Color color;
  final List<Color> knobColors;
  final String knobIcon;
  final String value;
  final String caption;
  final double height;

  /// Calories draws the whole gauge 5px lower than Steps (measured).
  final double offsetY;

  static const _centerY = 156.3;
  static const _radius = 134.5;
  static const _stroke = 24.0;
  static const _knob = 48.0;
  static const _start = 135.0; // degrees, bottom-left
  static const _sweep = 270.0;

  @override
  Widget build(BuildContext context) {
    final centerY = (_centerY + offsetY).h;
    final radius = _radius.w;
    final knobAngle = (_start + _sweep * progress) * math.pi / 180;

    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, box) {
          final center = Offset(box.maxWidth / 2, centerY);
          final knobCenter =
              center +
              Offset(math.cos(knobAngle), math.sin(knobAngle)) * radius;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _ArcPainter(
                    center: center,
                    radius: radius,
                    stroke: _stroke.w,
                    progress: progress,
                    color: color,
                    fadeFrom: (25 + offsetY).h,
                    fadeTo: (191 + offsetY).h,
                  ),
                ),
              ),
              Positioned(
                left: knobCenter.dx - _knob.w / 2,
                top: knobCenter.dy - _knob.w / 2,
                child: Container(
                  width: _knob.w,
                  height: _knob.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bg, width: 4),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: knobColors,
                    ),
                  ),
                  child: SvgPicture.asset(knobIcon, width: 24.w, height: 24.w),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: (98.5 + offsetY).h, // measured: glyph top 380 abs
                child: Column(
                  spacing: 4.h,
                  children: [
                    Text(
                      value,
                      // figma: 48 / w500 / h1 (no text style)
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 48.sp,
                        height: 1,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        fontVariations: const [FontVariation.weight(500)],
                      ),
                    ),
                    Text(
                      caption,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.center,
    required this.radius,
    required this.stroke,
    required this.progress,
    required this.color,
    required this.fadeFrom,
    required this.fadeTo,
  });

  final Offset center;
  final double radius;
  final double stroke;
  final double progress;
  final Color color;
  final double fadeFrom;
  final double fadeTo;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = ArcGauge._start * math.pi / 180;
    const sweep = ArcGauge._sweep * math.pi / 180;

    // Arcs fade out downwards (measured: opaque at fadeFrom, gone at
    // fadeTo); the gauge is clipped at its bottom edge.
    canvas.saveLayer(Offset.zero & Size(size.width, size.height), Paint());
    canvas.clipRect(Rect.fromLTRB(0, -stroke, size.width, size.height));
    Paint arc(Color c) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = c;
    canvas.drawArc(rect, start, sweep, false, arc(AppColors.white100));
    canvas.drawArc(rect, start, sweep * progress, false, arc(color));
    final fade = Paint()
      ..blendMode = BlendMode.dstIn
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Colors.black, Colors.black, Colors.transparent],
        stops: [0, fadeFrom / size.height, fadeTo / size.height],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Rect.fromLTRB(0, -stroke, size.width, size.height), fade);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress || old.color != color || old.center != center;
}
