import '../../domain/entities/training_history.dart';

/// Parses `assets/dummy/training_history.json` (values from Figma).
class TrainingHistoryModel extends TrainingHistory {
  const TrainingHistoryModel(super.records);

  factory TrainingHistoryModel.fromJson(Map<String, dynamic> json) {
    return TrainingHistoryModel({
      for (final period in HistoryPeriod.values)
        period: [
          for (final r in (json[period.name] as List? ?? const []))
            HistoryRecord(
              id: r['id'] as String,
              activity: HistoryActivity.values.byName(r['activity'] as String),
              title: r['title'] as String,
              duration: r['duration'] as String,
              calories: r['calories'] as String,
              date: r['date'] as String,
              distance: r['distance'] as String?,
              unit: r['unit'] as String?,
            ),
        ],
    });
  }
}
