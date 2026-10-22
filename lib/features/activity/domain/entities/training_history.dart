import 'package:equatable/equatable.dart';

/// Day / Month / Year tab of Training History.
enum HistoryPeriod { day, month, year }

/// Activity kinds in Training History (icon per kind).
enum HistoryActivity { running, walking, cycling, exercise, rowing }

/// One Training History item (Figma *Activity Info*).
class HistoryRecord extends Equatable {
  const HistoryRecord({
    required this.id,
    required this.activity,
    required this.title,
    required this.duration,
    required this.calories,
    required this.date,
    this.distance,
    this.unit,
  });

  final String id;
  final HistoryActivity activity;
  final String title;
  final String duration;
  final String calories;
  final String date;

  /// Null → distance hidden (Exercise).
  final String? distance;
  final String? unit;

  @override
  List<Object?> get props => [
    id,
    activity,
    title,
    duration,
    calories,
    date,
    distance,
    unit,
  ];
}

/// Records per tab (683 "Training History" Daily/Monthly/Yearly).
class TrainingHistory extends Equatable {
  const TrainingHistory(this.records);

  final Map<HistoryPeriod, List<HistoryRecord>> records;

  List<HistoryRecord> of(HistoryPeriod period) => records[period] ?? const [];

  /// Copy without the record [id] (in every period).
  TrainingHistory without(String id) => TrainingHistory({
    for (final e in records.entries)
      e.key: [
        for (final r in e.value)
          if (r.id != id) r,
      ],
  });

  @override
  List<Object?> get props => [records];
}
