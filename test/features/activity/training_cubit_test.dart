import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/entities/activity_overview.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/entities/training_session.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/repositories/training_repository.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/usecases/get_training_setup_usecase.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/manager/training/training_cubit.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/manager/training/training_state.dart';
import 'package:flutter_test/flutter_test.dart';

const _setup = TrainingSetup(
  signalLevel: 6,
  signalBars: 8,
  weatherCondition: 'partly_cloudy',
  temperature: '24°',
  targetHints: {
    TrainingTarget.step: 5000,
    TrainingTarget.distance: 5,
    TrainingTarget.time: 30,
    TrainingTarget.calories: 500,
  },
  coveredKm: 2.4,
  route: [(x: 0, y: 0), (x: 10, y: 10)],
  summary: TrainingRecord(
    type: TrainingType.walking,
    title: 'Walking',
    duration: '1h 15m 10s',
    calories: '2400 cal',
    date: '7 July',
    distance: '',
    unit: 'km',
  ),
);

class _Repo implements TrainingRepository {
  _Repo(this.result);

  final Either<Failure, TrainingSetup> result;

  @override
  Future<Either<Failure, TrainingSetup>> getSetup() async => result;
}

TrainingPhase _phase(TrainingCubit c) => (c.state as TrainingLoaded).phase;

void main() {
  late TrainingCubit cubit;

  setUp(() async {
    cubit = TrainingCubit(GetTrainingSetupUseCase(_Repo(const Right(_setup))));
    await cubit.loadData(TrainingType.walking);
  });

  tearDown(() => cubit.close());

  test('loads setup in idle', () {
    expect(
      cubit.state,
      const TrainingLoaded(setup: _setup, type: TrainingType.walking),
    );
  });

  test('emits error on failure', () async {
    final c = TrainingCubit(
      GetTrainingSetupUseCase(_Repo(const Left(UnexpectedFailure('x')))),
    );
    await c.loadData();
    expect(c.state, const TrainingError('x'));
    await c.close();
  });

  test('full flow: target → distance → walking → pause → reached', () {
    cubit.openTargetSheet();
    expect(_phase(cubit), TrainingPhase.choosingTarget);

    cubit.selectTarget(TrainingTarget.distance);
    expect(_phase(cubit), TrainingPhase.settingTarget);

    cubit.setTargetValue(null); // empty → placeholder 5
    var s = cubit.state as TrainingLoaded;
    expect(s.phase, TrainingPhase.targetSet);
    expect(s.targetValue, 5);

    cubit.start();
    s = cubit.state as TrainingLoaded;
    expect(s.phase, TrainingPhase.running);
    expect(s.currentValue, 0);

    cubit.togglePause();
    expect(_phase(cubit), TrainingPhase.paused);
    cubit.togglePause();
    expect(_phase(cubit), TrainingPhase.running);

    cubit.updateValue(5.2);
    s = cubit.state as TrainingLoaded;
    expect(s.phase, TrainingPhase.targetReached);
    expect(s.currentValue, 5);

    cubit.continueTraining();
    expect(_phase(cubit), TrainingPhase.running);
  });

  test('play without target opens Set Target', () {
    cubit.start();
    expect(_phase(cubit), TrainingPhase.choosingTarget);
    cubit.dismissSheet();
    expect(_phase(cubit), TrainingPhase.idle);
  });

  test('step / time / calories targets run like distance', () {
    for (final (target, value) in [
      (TrainingTarget.step, 4000.0),
      (TrainingTarget.time, 20.0),
      (TrainingTarget.calories, 300.0),
    ]) {
      fakeAsync((async) {
        cubit.openTargetSheet();
        cubit.selectTarget(target);
        var s = cubit.state as TrainingLoaded;
        expect(s.target, target);
        expect(s.targetValue, isNull); // other unit → cleared
        expect(s.phase, TrainingPhase.settingTarget);

        cubit.setTargetValue(value);
        cubit.start();
        async.elapse(TrainingCubit.tick * TrainingCubit.ticksToTarget);
        s = cubit.state as TrainingLoaded;
        expect(s.phase, TrainingPhase.targetReached);
        expect(s.currentValue, value);
        expect(s.coveredKm, target.kmFor(value));
        cubit.finish();
      });
    }
  });

  test('finish ends the session with the distance walked', () {
    cubit.setTargetValue(3);
    cubit.start();
    cubit.updateValue(1.2);
    cubit.finish();
    final s = cubit.state as TrainingLoaded;
    expect(s.phase, TrainingPhase.targetReached);
    expect(s.currentValue, 1.2);
  });

  test('dummy walk reaches the target by itself, pause stops it', () {
    fakeAsync((async) {
      cubit.setTargetValue(5);
      cubit.start();

      async.elapse(TrainingCubit.tick * 4);
      var s = cubit.state as TrainingLoaded;
      expect(s.currentValue, closeTo(0.5, 1e-9));
      expect(s.elapsed, const Duration(minutes: 6)); // 0.5 km at 5 km/h

      cubit.togglePause();
      async.elapse(TrainingCubit.tick * 10);
      expect((cubit.state as TrainingLoaded).currentValue, closeTo(0.5, 1e-9));

      cubit.togglePause();
      async.elapse(TrainingCubit.tick * TrainingCubit.ticksToTarget);
      s = cubit.state as TrainingLoaded;
      expect(s.phase, TrainingPhase.targetReached);
      expect(s.currentValue, 5);
      expect(s.progress, 1);

      // Continue training walks on past the target.
      cubit.continueTraining();
      async.elapse(TrainingCubit.tick * 2);
      s = cubit.state as TrainingLoaded;
      expect(s.phase, TrainingPhase.running);
      expect(s.currentValue, greaterThan(5));
      cubit.finish();
    });
  });
}
