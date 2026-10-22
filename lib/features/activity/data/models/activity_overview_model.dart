import '../../domain/entities/activity_overview.dart';
import '../../domain/entities/training_index.dart';

/// Parses `assets/dummy/activity.json` (values from Figma).
class ActivityOverviewModel extends ActivityOverview {
  const ActivityOverviewModel({
    required super.userName,
    required super.avatar,
    required super.history,
    required super.trainingIndex,
  });

  factory ActivityOverviewModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return ActivityOverviewModel(
      userName: user['name'] as String,
      avatar: user['avatar'] as String,
      history: [
        for (final h in json['history'] as List)
          TrainingRecord(
            type: TrainingType.values.byName(h['type'] as String),
            title: h['title'] as String,
            duration: h['duration'] as String,
            calories: h['calories'] as String,
            date: h['date'] as String,
            distance: h['distance'] as String,
            unit: h['unit'] as String,
          ),
      ],
      trainingIndex: [
        for (final t in json['training_index'] as List)
          TrainingIndexSummary(
            kind: switch (t['kind'] as String) {
              'vo2_max' => TrainingIndexKind.vo2Max,
              _ => TrainingIndexKind.fitnessCondition,
            },
            title: t['title'] as String,
            value: t['value'] as String,
            caption: t['caption'] as String,
            marker: (t['marker'] as num).toDouble(),
            minLabel: t['min_label'] as String,
            maxLabel: t['max_label'] as String,
          ),
      ],
    );
  }
}
