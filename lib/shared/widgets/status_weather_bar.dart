import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import 'weather_badge.dart';

/// Figma component "Status and Weather" (`692:13426`), top of the training
/// map: [location + GPS signal bars] · gap 4 · [WeatherBadge] ····· GPS
/// button (40, padding 8). All pills `bgSecondary`, fully rounded.
class StatusWeatherBar extends StatelessWidget {
  const StatusWeatherBar({
    super.key,
    required this.signalLevel,
    required this.temperature,
    this.condition = WeatherCondition.partlyCloudy,
    this.signalBars = 8,
    this.onGpsTap,
  });

  /// Filled (green) bars out of [signalBars].
  final int signalLevel;
  final int signalBars;
  final String temperature;
  final WeatherCondition condition;
  final VoidCallback? onGpsTap;

  @override
  Widget build(BuildContext context) {
    final pill = BoxDecoration(
      color: AppColors.bgSecondary,
      borderRadius: BorderRadius.circular(AppRadius.full),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.s1.w,
          children: [
            // "Battery and Signal": padding 8/12, gap 8.
            Container(
              height: 40.w,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: pill,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.s2.w,
                children: [
                  SvgPicture.asset(
                    'assets/icons/location_arrow.svg',
                    width: 24.w,
                    height: 24.w,
                  ),
                  _SignalBars(level: signalLevel, total: signalBars),
                ],
              ),
            ),
            WeatherBadge(
              condition: condition,
              temperature: temperature,
              variant: WeatherBadgeVariant.status,
            ),
          ],
        ),
        GestureDetector(
          onTap: onGpsTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: pill,
            child: SvgPicture.asset(
              'assets/icons/gps.svg',
              width: 24.w,
              height: 24.w,
            ),
          ),
        ),
      ],
    );
  }
}

/// "Bar Graph": 4×16 segments (radius 99), gap 2 — filled `bgSuccess`,
/// rest white 40%.
class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.level, required this.total});

  final int level;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2.w, // figma
      children: [
        for (var i = 0; i < total; i++)
          Container(
            width: 4.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: i < level ? AppColors.bgSuccess : AppColors.textTertiary,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
      ],
    );
  }
}
