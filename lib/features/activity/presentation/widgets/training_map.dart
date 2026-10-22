import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../shared/widgets/status_weather_bar.dart';
import '../../../../shared/widgets/weather_badge.dart';
import '../../domain/entities/training_session.dart';

/// Figma "Map" (424×617): "Map Image" (image fill, radius 24, exported
/// with its 1px border → `assets/images/training_map.png`).
/// Top: [StatusWeatherBar] at (12, 12). Centre: location marker, or — during
/// a session — the route line ([RoutePainter]) with start dot and heading.
class TrainingMap extends StatelessWidget {
  const TrainingMap({
    super.key,
    required this.setup,
    required this.showRoute,
    this.progress = 1,
  });

  final TrainingSetup setup;
  final bool showRoute;

  /// 0..1 of the route walked so far (dummy walk); 1 = full design route.
  final double progress;

  /// Map frame of the design; route coordinates are relative to it.
  static const designSize = Size(424, 617);

  static const _image = 'assets/images/training_map.png';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xLarge.r),
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset(_image, fit: BoxFit.fill)),
          // The map flexes with the screen height: route coordinates are
          // scaled from the 424×617 design frame to the actual size.
          Positioned.fill(
            child: showRoute
                ? _Route(route: setup.route, progress: progress)
                : Center(
                    // figma: marker 24 at (201, 297) = centre.
                    child: SvgPicture.asset(
                      'assets/icons/map_location.svg',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
          ),
          Positioned(
            left: 12.w,
            top: 12.h,
            right: 11.w, // figma: 401 wide
            child: StatusWeatherBar(
              signalLevel: setup.signalLevel,
              signalBars: setup.signalBars,
              temperature: setup.temperature,
              condition: _condition(setup.weatherCondition),
            ),
          ),
        ],
      ),
    );
  }

  static WeatherCondition _condition(String value) {
    for (final c in WeatherCondition.values) {
      final snake = c.name.replaceAllMapped(
        RegExp('[A-Z]'),
        (m) => '_${m[0]!.toLowerCase()}',
      );
      if (snake == value) return c;
    }
    return WeatherCondition.partlyCloudy;
  }
}

/// Route line + start dot ([RoutePainter]) and the heading arrow
/// (`route_heading.svg`, exported "Icons" rotated 23°) at its design spot.
class _Route extends StatelessWidget {
  const _Route({required this.route, required this.progress});

  final List<MapPoint> route;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final sx = box.maxWidth / TrainingMap.designSize.width;
        final sy = box.maxHeight / TrainingMap.designSize.height;
        return _stack(sx, sy);
      },
    );
  }

  Widget _stack(double sx, double sy) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: RoutePainter(
              points: route,
              designSize: TrainingMap.designSize,
              progress: progress,
            ),
          ),
        ),
        // figma: arrow box 31.47 at (288.77, 218) in the map — shown once
        // the walk reaches the end of the design route.
        if (progress >= 1)
          Positioned(
            left: 288.765 * sx,
            top: 218 * sy,
            child: SvgPicture.asset(
              'assets/icons/route_heading.svg',
              width: 31.469 * sx,
              height: 31.469 * sx,
            ),
          ),
      ],
    );
  }
}

/// Draws the walked route (Figma "Vector 18": stroke 2 `mapRoute`, round
/// caps, corner radius 4 ≈ round joins) from design-space [points], plus
/// the start dot (8 `mapRoute`, centre 4 `mapRouteDot`) on the last point.
/// The walk goes from the last point to the first; with [progress] < 1 only
/// that part is drawn and a position dot marks its tip.
class RoutePainter extends CustomPainter {
  const RoutePainter({
    required this.points,
    required this.designSize,
    this.progress = 1,
  });

  final List<MapPoint> points;
  final Size designSize;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final sx = size.width / designSize.width;
    final sy = size.height / designSize.height;
    Offset at(MapPoint p) => Offset(p.x * sx, p.y * sy);

    // Walk order: start (last point) → current position (first point).
    final walk = points.reversed.map(at).toList();
    var total = 0.0;
    for (var i = 1; i < walk.length; i++) {
      total += (walk[i] - walk[i - 1]).distance;
    }
    var left = total * progress.clamp(0, 1);
    final path = Path()..moveTo(walk.first.dx, walk.first.dy);
    var tip = walk.first;
    for (var i = 1; i < walk.length && left > 0; i++) {
      final seg = walk[i] - walk[i - 1];
      final len = seg.distance;
      tip = len <= left ? walk[i] : walk[i - 1] + seg * (left / len);
      path.lineTo(tip.dx, tip.dy);
      left -= len;
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.mapRoute
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * sx
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final start = walk.first;
    canvas.drawCircle(start, 4 * sx, Paint()..color = AppColors.mapRoute);
    canvas.drawCircle(start, 2 * sx, Paint()..color = AppColors.mapRouteDot);
    if (progress < 1) {
      // Current position (no design — same look as the start dot).
      canvas.drawCircle(tip, 6 * sx, Paint()..color = AppColors.mapRoute);
      canvas.drawCircle(tip, 3 * sx, Paint()..color = AppColors.mapRouteDot);
    }
  }

  @override
  bool shouldRepaint(RoutePainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.designSize != designSize ||
      oldDelegate.progress != progress;
}
