import 'package:equatable/equatable.dart';

import '../../../../shared/models/heart_rate.dart';

export '../../../../shared/models/heart_rate.dart';

/// Labels of the "Day Summary" grid.
enum HeartRateStatType { range, rest, mid, average }

/// Everything shown on Heartrate Monitoring (683:54394 / 54343 / 54445).
/// Day, Month and Year show the same content in the design.
class HeartRateOverview extends Equatable {
  const HeartRateOverview({
    required this.current,
    required this.min,
    required this.max,
    required this.bars,
    required this.summary,
    required this.zones,
  });

  final int current;
  final int min;
  final int max;
  final List<ChartBar> bars;
  final List<HeartRateStat> summary;
  final List<HeartZone> zones;

  @override
  List<Object?> get props => [current, min, max, bars, summary, zones];
}

/// One "Day Summary" cell: value in Bpm, e.g. "56-100" · Range.
class HeartRateStat extends Equatable {
  const HeartRateStat({required this.type, required this.value});

  final HeartRateStatType type;
  final String value;

  @override
  List<Object?> get props => [type, value];
}
