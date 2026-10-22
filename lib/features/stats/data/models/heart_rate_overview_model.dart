import '../../domain/entities/heart_rate_overview.dart';

/// Parses `heart_rate` of `assets/dummy/overview.json` (values from Figma).
class HeartRateOverviewModel extends HeartRateOverview {
  const HeartRateOverviewModel({
    required super.current,
    required super.min,
    required super.max,
    required super.bars,
    required super.summary,
    required super.zones,
  });

  factory HeartRateOverviewModel.fromJson(Map<String, dynamic> json) {
    double d(Object? v) => (v as num).toDouble();
    return HeartRateOverviewModel(
      current: json['current'] as int,
      min: json['min'] as int,
      max: json['max'] as int,
      bars: [
        for (final b in json['bars'] as List)
          ChartBar(left: d(b[0]), top: d(b[1]), height: d(b[2])),
      ],
      summary: [
        for (final s in json['summary'] as List)
          HeartRateStat(
            type: HeartRateStatType.values.byName(s['type'] as String),
            value: s['value'] as String,
          ),
      ],
      zones: [
        for (final z in json['zones'] as List)
          HeartZone(
            type: HeartZoneType.values.byName(z['zone'] as String),
            minutes: z['minutes'] as int,
            width: d(z['width']),
          ),
      ],
    );
  }
}
