import '../../domain/entities/metric_overview.dart';

/// Parses one metric of `assets/dummy/overview.json` (selected values from
/// the Figma screens, other bars proportional to their height).
class MetricOverviewModel extends MetricOverview {
  const MetricOverviewModel({
    required super.periods,
    required super.stats,
    required super.history,
  });

  factory MetricOverviewModel.fromJson(Map<String, dynamic> json) {
    final periods = json['periods'] as Map<String, dynamic>;

    OverviewPeriodData period(Map<String, dynamic> p) => OverviewPeriodData(
      title: p['title'] as String,
      date: p['date'] as String,
      caption: p['caption'] as String,
      selected: p['selected'] as int,
      bars: [
        for (final b in p['bars'] as List)
          OverviewBar(
            label: b['label'] as String,
            height: (b['height'] as num).toDouble(),
            value: b['value'] as String,
            progress: (b['progress'] as num).toDouble(),
          ),
      ],
    );

    return MetricOverviewModel(
      periods: {
        for (final p in OverviewPeriod.values)
          p: period(periods[p.name] as Map<String, dynamic>),
      },
      stats: [
        for (final s in json['stats'] as List)
          OverviewStat(
            icon: s['icon'] as String,
            value: s['value'] as String,
            unit: s['unit'] as String,
          ),
      ],
      history: [
        for (final h in json['history'] as List)
          OverviewHistory(
            value: h['value'] as String,
            caption: h['caption'] as String,
            date: h['date'] as String,
          ),
      ],
    );
  }
}
