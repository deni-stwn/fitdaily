import 'package:equatable/equatable.dart';

/// Training Index screens (Activity "Training Index" cards).
enum TrainingIndexKind { fitnessCondition, vo2Max }

/// Day / Month tab of the Training Index screens.
enum TrainingIndexPeriod { day, month }

/// Level scale steps (Figma legend "Very Poor" … "Superior").
enum TrainingLevel { veryPoor, poor, fair, normal, good, veryGood, superior }

/// One dot of the line chart: [x] 0–1 of the plot width, [y] 0–100.
class ChartPoint extends Equatable {
  const ChartPoint({required this.x, required this.y});

  final double x;
  final double y;

  @override
  List<Object?> get props => [x, y];
}

/// Fitness Condition (683:54496) / VO₂ Max (683:54551) content.
class TrainingIndexOverview extends Equatable {
  const TrainingIndexOverview({
    required this.value,
    required this.unit,
    this.rangeValue,
    this.rangeUnit,
    this.date,
    required this.points,
    required this.xLabels,
    required this.referenceValue,
    required this.referenceStart,
    required this.levelTitle,
    required this.levelCaption,
    this.levelValue,
    this.levelUnit,
    required this.segments,
    required this.legend,
    required this.marker,
    this.explanation,
    this.recommendation,
  });

  /// "84" + "Bpm".
  final String value;
  final String unit;

  /// Fitness Condition: "47-100" + "Bpm" on the right.
  final String? rangeValue;
  final String? rangeUnit;

  /// VO₂ Max: "12 July 2026" on the right.
  final String? date;

  final List<ChartPoint> points;
  final List<String> xLabels;

  /// White reference line value (0–100) and start (0–1 of plot width).
  final double referenceValue;
  final double referenceStart;

  /// "Declining" / "Good" + caption "01/07" / "Level".
  final String levelTitle;
  final String levelCaption;

  /// VO₂ Max: "0" + "ml/kg/min".
  final String? levelValue;
  final String? levelUnit;

  /// Bar segments and legend entries (they differ in the design).
  final List<TrainingLevel> segments;
  final List<TrainingLevel> legend;

  /// Triangle marker position, 0–1 of the bar width.
  final double marker;

  /// Fitness Condition only.
  final String? explanation;
  final String? recommendation;

  @override
  List<Object?> get props => [
    value,
    unit,
    rangeValue,
    rangeUnit,
    date,
    points,
    xLabels,
    referenceValue,
    referenceStart,
    levelTitle,
    levelCaption,
    levelValue,
    levelUnit,
    segments,
    legend,
    marker,
    explanation,
    recommendation,
  ];
}
