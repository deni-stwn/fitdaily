import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// Scanning state of the device list (not in Figma): radar rings pulsing
/// out of a brand circle + "Searching for devices…".
class ScanningIndicator extends StatefulWidget {
  const ScanningIndicator({super.key});

  @override
  State<ScanningIndicator> createState() => _ScanningIndicatorState();
}

class _ScanningIndicatorState extends State<ScanningIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 120.w;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s2.h,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => CustomPaint(
                    painter: _RadarPainter(progress: _controller.value),
                  ),
                ),
              ),
              Container(
                width: 40.w,
                height: 40.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.bgBrand,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/link.svg',
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            ],
          ),
        ),
        Text(
          LocaleKeys.device_setup_scanning.tr(context: context),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

/// Three staggered rings growing from the centre circle and fading out.
class _RadarPainter extends CustomPainter {
  const _RadarPainter({required this.progress});

  final double progress;

  static const _rings = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;
    final minRadius = maxRadius / 3;
    for (var i = 0; i < _rings; i++) {
      final t = (progress + i / _rings) % 1;
      final eased = Curves.easeOut.transform(t);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.iconBrandSecondary.withValues(
          alpha: math.max(0, 1 - t) * 0.8,
        );
      canvas.drawCircle(
        center,
        minRadius + (maxRadius - minRadius) * eased,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RadarPainter old) => old.progress != progress;
}
