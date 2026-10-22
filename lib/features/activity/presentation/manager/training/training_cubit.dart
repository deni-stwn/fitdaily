import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/entities/activity_overview.dart';
import '../../../domain/entities/training_session.dart';
import '../../../domain/usecases/get_training_setup_usecase.dart';
import 'training_state.dart';

/// Start Training flow: idle → Set Target → target input → target set →
/// session (pause) → target reached. Every target (step, distance, time,
/// calories) works the same way. No sensors: a dummy walk adds
/// target / [ticksToTarget] every [tick] (target reached after ~20 s) and
/// the simulated time follows a 5 km/h walk; [updateValue] can feed real
/// tracking later.
class TrainingCubit extends Cubit<TrainingState>
    with CancelableSafeCubitMixin<TrainingState> {
  TrainingCubit(this._getSetup) : super(TrainingInitial());

  final GetTrainingSetupUseCase _getSetup;

  /// Dummy walk speed (real time per simulated step).
  static const tick = Duration(milliseconds: 500);
  static const ticksToTarget = 40;

  /// Simulated pace: 5 km/h → 720 s per km.
  static const _secondsPerKm = 720;

  Timer? _ticker;

  /// After "Continue training" the walk goes on past the target.
  bool _reachedOnce = false;

  Future<void> loadData([TrainingType type = TrainingType.walking]) async {
    safeEmit(TrainingLoading());
    final result = await runCancelable(_getSetup.call());
    if (result == null) return;
    result.fold(
      (failure) => safeEmit(TrainingError(failure.message)),
      (setup) => safeEmit(TrainingLoaded(setup: setup, type: type)),
    );
  }

  TrainingLoaded? get _loaded {
    final s = state;
    return s is TrainingLoaded ? s : null;
  }

  void _emit(TrainingLoaded Function(TrainingLoaded s) update) {
    final s = _loaded;
    if (s != null) safeEmit(update(s));
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(tick, (_) => _tick());
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  Duration _elapsedFor(TrainingTarget target, double value) {
    if (target == TrainingTarget.time) {
      return Duration(seconds: (value * 60).round());
    }
    return Duration(seconds: (target.kmFor(value) * _secondsPerKm).round());
  }

  TrainingLoaded _progressTo(TrainingLoaded s, double value) {
    final target = s.targetValue;
    if (!_reachedOnce && target != null && value >= target) {
      _reachedOnce = true;
      _stopTicker();
      return s.copyWith(
        currentValue: target,
        elapsed: _elapsedFor(s.target, target),
        phase: TrainingPhase.targetReached,
      );
    }
    return s.copyWith(
      currentValue: value,
      elapsed: _elapsedFor(s.target, value),
    );
  }

  void _tick() => _emit((s) {
    if (s.phase != TrainingPhase.running) return s;
    final step = (s.targetValue ?? s.hint) / ticksToTarget;
    return _progressTo(s, s.currentValue + step);
  });

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }

  /// Back to the start screen (with or without a chosen target).
  TrainingPhase _restingPhase(TrainingLoaded s) =>
      s.targetValue == null ? TrainingPhase.idle : TrainingPhase.targetSet;

  /// Tap on the "Choose how you track…" / target pill.
  void openTargetSheet() => _emit((s) {
    if (s.hasSession) return s;
    return s.copyWith(phase: TrainingPhase.choosingTarget);
  });

  /// Tap outside the Set Target sheet / target input.
  void dismissSheet() => _emit(
    (s) =>
        s.phase == TrainingPhase.choosingTarget ||
            s.phase == TrainingPhase.settingTarget
        ? s.copyWith(phase: _restingPhase(s))
        : s,
  );

  /// Set Target option → its value input. Changing the kind clears the
  /// previous value (different unit).
  void selectTarget(TrainingTarget target) => _emit(
    (s) => s.copyWith(
      target: target,
      clearTarget: target != s.target,
      phase: TrainingPhase.settingTarget,
    ),
  );

  /// Setting icon in the target pill.
  void editTarget() => _emit(
    (s) => s.hasSession ? s : s.copyWith(phase: TrainingPhase.settingTarget),
  );

  /// "Done" in the target input; empty input uses the placeholder.
  void setTargetValue(double? value) => _emit((s) {
    final v = (value == null || value <= 0) ? s.hint : value;
    return s.copyWith(targetValue: v, phase: TrainingPhase.targetSet);
  });

  /// Play button. Without a target the Set Target sheet opens first.
  void start() => _emit((s) {
    if (s.targetValue == null) {
      return s.copyWith(phase: TrainingPhase.choosingTarget);
    }
    _reachedOnce = false;
    _startTicker();
    return s.copyWith(
      phase: TrainingPhase.running,
      currentValue: 0,
      elapsed: Duration.zero,
    );
  });

  /// Pause / resume button of the Active Session modal.
  void togglePause() => _emit((s) {
    switch (s.phase) {
      case TrainingPhase.running:
        _stopTicker();
        return s.copyWith(phase: TrainingPhase.paused);
      case TrainingPhase.paused:
        _startTicker();
        return s.copyWith(phase: TrainingPhase.running);
      default:
        return s;
    }
  });

  /// New value from tracking (target unit); reaching the target opens
  /// Target Reached.
  void updateValue(double value) => _emit(
    (s) => s.phase == TrainingPhase.running ? _progressTo(s, value) : s,
  );

  /// Finish button (right of pause): ends the session → Target Reached
  /// with the progress so far.
  void finish() => _emit((s) {
    if (!s.hasSession) return s;
    _stopTicker();
    _reachedOnce = true;
    return s.copyWith(phase: TrainingPhase.targetReached);
  });

  /// "Continue training" / close icon on Target Reached.
  void continueTraining() => _emit((s) {
    if (s.phase != TrainingPhase.targetReached) return s;
    _startTicker();
    return s.copyWith(phase: TrainingPhase.running);
  });
}
