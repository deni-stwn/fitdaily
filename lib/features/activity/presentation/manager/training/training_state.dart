import 'package:equatable/equatable.dart';

import '../../../domain/entities/activity_overview.dart';
import '../../../domain/entities/training_session.dart';

/// Steps of the Start Training flow (Figma frames in brackets).
enum TrainingPhase {
  /// Start Training — "Choose how you track your training" (683:53476).
  idle,

  /// Set Target sheet open (683:53521).
  choosingTarget,

  /// Target input open (Set Distance 683:53556; same modal for step, time
  /// and calories).
  settingTarget,

  /// Target chosen, not started yet (Distance Target 683:54595).
  targetSet,

  /// Session running (Walking Session 683:53588).
  running,

  /// Session paused (no frame — same screen, play icon).
  paused,

  /// Target Reached (683:53639).
  targetReached,
}

abstract class TrainingState extends Equatable {
  const TrainingState();

  @override
  List<Object?> get props => [];
}

class TrainingInitial extends TrainingState {}

class TrainingLoading extends TrainingState {}

class TrainingLoaded extends TrainingState {
  const TrainingLoaded({
    required this.setup,
    required this.type,
    this.phase = TrainingPhase.idle,
    this.target = TrainingTarget.distance,
    this.targetValue,
    this.currentValue = 0,
    this.elapsed = Duration.zero,
  });

  final TrainingSetup setup;
  final TrainingType type;
  final TrainingPhase phase;

  /// Selected target kind (design: By Distance).
  final TrainingTarget target;

  /// Chosen target in [target]'s unit (km, steps, minutes, kcal); null
  /// until "Done".
  final double? targetValue;

  /// Progress of the session in [target]'s unit (dummy walk).
  final double currentValue;

  /// Simulated session time.
  final Duration elapsed;

  /// Placeholder of the target input for [target].
  double get hint => setup.targetHints[target] ?? 0;

  /// Distance walked so far (route, summary).
  double get coveredKm => target.kmFor(currentValue);

  /// 0..1 of the target reached (route drawn so far).
  double get progress {
    final t = targetValue;
    if (t == null || t <= 0) return 0;
    return (currentValue / t).clamp(0, 1).toDouble();
  }

  /// Running, paused or finished: map shows the route, Active Session modal.
  bool get hasSession =>
      phase == TrainingPhase.running ||
      phase == TrainingPhase.paused ||
      phase == TrainingPhase.targetReached;

  TrainingLoaded copyWith({
    TrainingPhase? phase,
    TrainingTarget? target,
    double? targetValue,
    bool clearTarget = false,
    double? currentValue,
    Duration? elapsed,
  }) {
    return TrainingLoaded(
      setup: setup,
      type: type,
      phase: phase ?? this.phase,
      target: target ?? this.target,
      targetValue: clearTarget ? null : targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      elapsed: elapsed ?? this.elapsed,
    );
  }

  @override
  List<Object?> get props => [
    setup,
    type,
    phase,
    target,
    targetValue,
    currentValue,
    elapsed,
  ];
}

class TrainingError extends TrainingState {
  const TrainingError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
