import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_dimens.dart';
import '../../../generated/locale_keys.g.dart';
import '../../models/heart_rate.dart';
import 'legend_item.dart';
import 'segmented_progress_bar.dart';

/// Colour and label of each heart-rate zone.
extension HeartZoneTypeX on HeartZoneType {
  Color get color => switch (this) {
    HeartZoneType.light => AppColors.zoneLight,
    HeartZoneType.intensive => AppColors.zoneIntensive,
    HeartZoneType.aerobic => AppColors.zoneAerobic,
    HeartZoneType.anaerobic => AppColors.zoneAnaerobic,
    HeartZoneType.vo2max => AppColors.zoneVo2Max,
  };

  String get labelKey => switch (this) {
    HeartZoneType.light => LocaleKeys.home_zone_light,
    HeartZoneType.intensive => LocaleKeys.home_zone_intensive,
    HeartZoneType.aerobic => LocaleKeys.home_zone_aerobic,
    HeartZoneType.anaerobic => LocaleKeys.home_zone_anaerobic,
    HeartZoneType.vo2max => LocaleKeys.home_zone_vo2max,
  };
}

/// Figma *Segmented Progress Bar* with legend (Home heart-rate card,
/// Heartrate Monitoring "Heartrate zone"): zone bar, gap 16, one
/// [LegendItem] per zone (fill, gap 16).
class HeartZoneBreakdown extends StatelessWidget {
  const HeartZoneBreakdown({super.key, required this.zones});

  final List<HeartZone> zones;

  @override
  Widget build(BuildContext context) {
    final mins = LocaleKeys.home_mins.tr(context: context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s3.h,
      children: [
        SegmentedProgressBar(
          segments: [
            for (final z in zones) (width: z.width, color: z.type.color),
          ],
        ),
        Row(
          spacing: AppSpacing.s3.w,
          children: [
            for (final z in zones)
              Expanded(
                child: LegendItem(
                  color: z.type.color,
                  label: z.type.labelKey.tr(context: context),
                  value: '${z.minutes}',
                  unit: mins,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
