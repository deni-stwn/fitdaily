import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma component "Weather Badge" (`691:12791`) — `Status` property.
enum WeatherCondition {
  partlyCloudy,
  thunderstorm,
  mostlyCloudy,
  rainy,
  windy,
  sunny,
}

extension WeatherConditionX on WeatherCondition {
  /// 24×24 icon of the component variant (cloud-notif / cloud-lightning /
  /// cloud-sunny / cloud-snow / wind outline, sun-fog fill).
  String get icon => switch (this) {
    WeatherCondition.partlyCloudy =>
      'assets/icons/weather_partly_cloudy_outline.svg',
    WeatherCondition.thunderstorm => 'assets/icons/weather_thunderstorm.svg',
    WeatherCondition.mostlyCloudy => 'assets/icons/weather_mostly_cloudy.svg',
    WeatherCondition.rainy => 'assets/icons/weather_rainy.svg',
    WeatherCondition.windy => 'assets/icons/weather_windy.svg',
    WeatherCondition.sunny => 'assets/icons/weather_sunny.svg',
  };

  /// Icon in the "Status and Weather" bar: Partly Cloudy uses the filled
  /// cloud-notif there (training map); the others fall back to [icon].
  String get statusIcon => switch (this) {
    WeatherCondition.partlyCloudy => 'assets/icons/weather_partly_cloudy.svg',
    _ => icon,
  };
}

/// Look of [WeatherBadge].
enum WeatherBadgeVariant {
  /// Component set (`691:12791`): 48 high, padding 12/16, `white200`,
  /// icon · gap 8 · [condition / gap 4 / temperature] (10 Medium, lh 100%).
  standard,

  /// Detached copy inside "Status and Weather" (`692:13426`): 40 high,
  /// padding 12, `bgSecondary`, icon · gap 8 · temperature (`bodyLarge`).
  status,
}

/// Figma "Weather Badge".
class WeatherBadge extends StatelessWidget {
  const WeatherBadge({
    super.key,
    required this.condition,
    required this.temperature,
    this.label,
    this.variant = WeatherBadgeVariant.standard,
  });

  final WeatherCondition condition;

  /// e.g. "24°".
  final String temperature;

  /// Condition text of the standard variant (Figma default "Cloudy").
  final String? label;
  final WeatherBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final status = variant == WeatherBadgeVariant.status;
    return Container(
      height: (status ? 40 : 48).w,
      padding: EdgeInsets.symmetric(horizontal: (status ? 12 : 16).w),
      decoration: BoxDecoration(
        color: status ? AppColors.bgSecondary : AppColors.white200,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s2.w,
        children: [
          SvgPicture.asset(
            status ? condition.statusIcon : condition.icon,
            width: 24.w,
            height: 24.w,
          ),
          if (status)
            Text(temperature, style: AppTextStyles.bodyLarge)
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s1.h,
              children: [
                if (label != null) Text(label!, style: _small),
                Text(temperature, style: _small),
              ],
            ),
        ],
      ),
    );
  }

  /// figma: Instrument Sans 10 Medium, line height 100% (no text style).
  static TextStyle get _small => AppTextStyles.bodySmall.copyWith(
    fontSize: 10.sp,
    height: 1,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
    fontVariations: const [FontVariation.weight(500)],
  );
}
