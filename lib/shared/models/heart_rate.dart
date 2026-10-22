import 'package:equatable/equatable.dart';

/// One bar of the heart-rate candle chart, in Figma chart coordinates
/// (357 × 111.56 area). Shared by Home and Heartrate Monitoring.
class ChartBar extends Equatable {
  const ChartBar({required this.left, required this.top, required this.height});

  final double left;
  final double top;
  final double height;

  @override
  List<Object?> get props => [left, top, height];
}

enum HeartZoneType { light, intensive, aerobic, anaerobic, vo2max }

class HeartZone extends Equatable {
  const HeartZone({
    required this.type,
    required this.minutes,
    required this.width,
  });

  final HeartZoneType type;
  final int minutes;

  /// Segment width in the zone bar (Figma px of 384).
  final double width;

  @override
  List<Object?> get props => [type, minutes, width];
}
