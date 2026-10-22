import '../../domain/entities/activity_overview.dart';
import '../../domain/entities/training_session.dart';

/// Parses `assets/dummy/training.json` (values from Figma).
class TrainingSetupModel extends TrainingSetup {
  const TrainingSetupModel({
    required super.signalLevel,
    required super.signalBars,
    required super.weatherCondition,
    required super.temperature,
    required super.targetHints,
    required super.coveredKm,
    required super.route,
    required super.summary,
  });

  factory TrainingSetupModel.fromJson(Map<String, dynamic> json) {
    final gps = json['gps'] as Map<String, dynamic>;
    final weather = json['weather'] as Map<String, dynamic>;
    final session = json['session'] as Map<String, dynamic>;
    final summary = json['summary'] as Map<String, dynamic>;
    return TrainingSetupModel(
      signalLevel: gps['signal_level'] as int,
      signalBars: gps['signal_bars'] as int,
      weatherCondition: weather['condition'] as String,
      temperature: weather['temperature'] as String,
      targetHints: {
        for (final t in TrainingTarget.values)
          t: ((json['target_hints'] as Map<String, dynamic>)[t.name] as num)
              .toDouble(),
      },
      coveredKm: (session['covered_km'] as num).toDouble(),
      route: [
        for (final p in session['route'] as List)
          (x: ((p as List)[0] as num).toDouble(), y: (p[1] as num).toDouble()),
      ],
      summary: TrainingRecord(
        type: TrainingType.values.byName(summary['type'] as String),
        title: summary['title'] as String,
        duration: summary['duration'] as String,
        calories: summary['calories'] as String,
        date: summary['date'] as String,
        distance: '',
        unit: 'km',
      ),
    );
  }
}
