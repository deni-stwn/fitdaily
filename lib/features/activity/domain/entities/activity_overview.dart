import 'package:equatable/equatable.dart';

import 'training_index.dart';

/// Kinds of training (Start Training buttons, history icons).
enum TrainingType { walking, running, cycling, gym }

/// Everything shown on Activity (683:53210).
class ActivityOverview extends Equatable {
  const ActivityOverview({
    required this.userName,
    required this.avatar,
    required this.history,
    required this.trainingIndex,
  });

  final String userName;

  /// Asset path.
  final String avatar;
  final List<TrainingRecord> history;

  /// Training Index cards (Fitness condition · VO₂ Max).
  final List<TrainingIndexSummary> trainingIndex;

  @override
  List<Object?> get props => [userName, avatar, history, trainingIndex];
}

/// One History item (Figma *Activity Info*).
class TrainingRecord extends Equatable {
  const TrainingRecord({
    required this.type,
    required this.title,
    required this.duration,
    required this.calories,
    required this.date,
    required this.distance,
    required this.unit,
  });

  final TrainingType type;
  final String title;
  final String duration;
  final String calories;
  final String date;
  final String distance;
  final String unit;

  @override
  List<Object?> get props => [
    type,
    title,
    duration,
    calories,
    date,
    distance,
    unit,
  ];
}

/// One Training Index card: title, big value, caption and the position of
/// the marker on the scale (0–1) with the scale's end labels.
class TrainingIndexSummary extends Equatable {
  const TrainingIndexSummary({
    required this.kind,
    required this.title,
    required this.value,
    required this.caption,
    required this.marker,
    required this.minLabel,
    required this.maxLabel,
  });

  final TrainingIndexKind kind;
  final String title;
  final String value;
  final String caption;
  final double marker;
  final String minLabel;
  final String maxLabel;

  @override
  List<Object?> get props => [
    kind,
    title,
    value,
    caption,
    marker,
    minLabel,
    maxLabel,
  ];
}
