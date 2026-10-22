import 'package:equatable/equatable.dart';

/// Metrics with an overview screen (Step / Calories Overview).
enum OverviewMetric { steps, calories }

/// Tabs of the overview (Day · Month · Year).
enum OverviewPeriod { day, month, year }

/// Everything shown on a metric overview (683:54172 / 683:54259).
class MetricOverview extends Equatable {
  const MetricOverview({
    required this.periods,
    required this.stats,
    required this.history,
  });

  final Map<OverviewPeriod, OverviewPeriodData> periods;

  /// Stats row under the gauge (Steps only).
  final List<OverviewStat> stats;

  /// History list under the summary (Steps only).
  final List<OverviewHistory> history;

  @override
  List<Object?> get props => [periods, stats, history];
}

class OverviewPeriodData extends Equatable {
  const OverviewPeriodData({
    required this.title,
    required this.date,
    required this.caption,
    required this.selected,
    required this.bars,
  });

  final String title;
  final String date;

  /// Gauge caption, e.g. "of 1M Steps".
  final String caption;

  /// Bar selected initially.
  final int selected;
  final List<OverviewBar> bars;

  @override
  List<Object?> get props => [title, date, caption, selected, bars];
}

/// Summary bar: label, height (Figma px, area 86) and the gauge value.
class OverviewBar extends Equatable {
  const OverviewBar({
    required this.label,
    required this.height,
    required this.value,
    required this.progress,
  });

  final String label;
  final double height;
  final String value;

  /// 0..1 of the goal.
  final double progress;

  @override
  List<Object?> get props => [label, height, value, progress];
}

class OverviewStat extends Equatable {
  const OverviewStat({
    required this.icon,
    required this.value,
    required this.unit,
  });

  /// Asset path.
  final String icon;
  final String value;
  final String unit;

  @override
  List<Object?> get props => [icon, value, unit];
}

class OverviewHistory extends Equatable {
  const OverviewHistory({
    required this.value,
    required this.caption,
    required this.date,
  });

  final String value;
  final String caption;
  final String date;

  @override
  List<Object?> get props => [value, caption, date];
}
