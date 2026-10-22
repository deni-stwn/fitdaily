import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/activity_overview.dart';

/// Icon (24, coloured) and name of each training type in the training flow.
/// Only Walking is designed; the others reuse the Activity icons.
extension TrainingTypeStyle on TrainingType {
  String get sessionIcon => switch (this) {
    TrainingType.walking => 'assets/icons/history_walk.svg',
    TrainingType.running => 'assets/icons/history_run.svg',
    TrainingType.cycling => 'assets/icons/training_bike.svg',
    TrainingType.gym => 'assets/icons/training_gym.svg',
  };

  String get labelKey => switch (this) {
    TrainingType.walking => LocaleKeys.training_walking,
    TrainingType.running => LocaleKeys.training_running,
    TrainingType.cycling => LocaleKeys.training_cycling,
    TrainingType.gym => LocaleKeys.training_gym,
  };
}

/// "5" for 5.0, "2.4" for 2.4 (one decimal).
String formatKm(double km) {
  final r = (km * 10).round() / 10;
  return r == r.roundToDouble() ? r.toInt().toString() : r.toString();
}

/// "1h 15m 10s" / "40m 15s" / "12s" (Activity Info duration format).
String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  if (h > 0) return '${h}h ${m}m ${s}s';
  if (m > 0) return '${m}m ${s}s';
  return '${s}s';
}
