import '../../domain/entities/training_index.dart';

/// Parses one entry of `assets/dummy/training_index.json` (values from Figma).
class TrainingIndexModel extends TrainingIndexOverview {
  const TrainingIndexModel({
    required super.value,
    required super.unit,
    super.rangeValue,
    super.rangeUnit,
    super.date,
    required super.points,
    required super.xLabels,
    required super.referenceValue,
    required super.referenceStart,
    required super.levelTitle,
    required super.levelCaption,
    super.levelValue,
    super.levelUnit,
    required super.segments,
    required super.legend,
    required super.marker,
    super.explanation,
    super.recommendation,
  });

  factory TrainingIndexModel.fromJson(Map<String, dynamic> json) {
    final level = json['level'] as Map<String, dynamic>;
    List<TrainingLevel> levels(String key) => [
      for (final l in level[key] as List)
        TrainingLevel.values.byName(l as String),
    ];
    return TrainingIndexModel(
      value: json['value'] as String,
      unit: json['unit'] as String,
      rangeValue: json['range_value'] as String?,
      rangeUnit: json['range_unit'] as String?,
      date: json['date'] as String?,
      points: [
        for (final p in json['points'] as List)
          ChartPoint(
            x: (p['x'] as num).toDouble(),
            y: (p['y'] as num).toDouble(),
          ),
      ],
      xLabels: [for (final l in json['x_labels'] as List) l as String],
      referenceValue: (json['reference_value'] as num).toDouble(),
      referenceStart: (json['reference_start'] as num).toDouble(),
      levelTitle: level['title'] as String,
      levelCaption: level['caption'] as String,
      levelValue: level['value'] as String?,
      levelUnit: level['unit'] as String?,
      segments: levels('segments'),
      legend: levels('legend'),
      marker: (level['marker'] as num).toDouble(),
      explanation: level['explanation'] as String?,
      recommendation: level['recommendation'] as String?,
    );
  }
}
