import 'package:equatable/equatable.dart';

import 'activity_overview.dart';

/// "Set Target" options (Choose Target modal), top → bottom.
enum TrainingTarget { step, distance, time, calories }

/// Dummy conversions of a target value to distance (no sensors):
/// step 0.8 m, walking 5 km/h, 480 kcal per km (design: 5 km → 2400 cal).
extension TrainingTargetX on TrainingTarget {
  static const kmPerStep = 0.0008;
  static const kmPerMinute = 5 / 60;
  static const kcalPerKm = 480.0;

  /// Distance walked when [value] (in this target's unit) is reached.
  double kmFor(double value) => switch (this) {
    TrainingTarget.step => value * kmPerStep,
    TrainingTarget.distance => value,
    TrainingTarget.time => value * kmPerMinute,
    TrainingTarget.calories => value / kcalPerKm,
  };
}

/// A point in the 424×617 map frame of the Figma design (design px).
typedef MapPoint = ({double x, double y});

/// Dummy data for the training session (Activity - Start Training
/// 683:53476 … Target Reached 683:53639): GPS/weather badges, the
/// placeholder input value, the recorded route and the finish summary.
class TrainingSetup extends Equatable {
  const TrainingSetup({
    required this.signalLevel,
    required this.signalBars,
    required this.weatherCondition,
    required this.temperature,
    required this.targetHints,
    required this.coveredKm,
    required this.route,
    required this.summary,
  });

  /// GPS bars filled out of [signalBars].
  final int signalLevel;
  final int signalBars;

  /// Weather Badge variant in snake_case (e.g. `partly_cloudy`).
  final String weatherCondition;
  final String temperature;

  /// Placeholder of each target input (distance "5" from the design;
  /// steps / minutes / kcal dummy) — used when the input is left empty.
  final Map<TrainingTarget, double> targetHints;

  /// Distance walked so far in the session (no GPS: dummy).
  final double coveredKm;

  /// Route line on the map, in map design coordinates.
  final List<MapPoint> route;

  /// Finish Session card (duration, calories, date; distance = target).
  final TrainingRecord summary;

  @override
  List<Object?> get props => [
    signalLevel,
    signalBars,
    weatherCondition,
    temperature,
    targetHints,
    coveredKm,
    route,
    summary,
  ];
}
