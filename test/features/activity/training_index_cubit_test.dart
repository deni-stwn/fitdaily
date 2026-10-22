import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/entities/training_index.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/repositories/training_index_repository.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/usecases/get_training_index_usecase.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/manager/training_index/training_index_cubit.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/manager/training_index/training_index_state.dart';
import 'package:flutter_test/flutter_test.dart';

const _overview = TrainingIndexOverview(
  value: '84',
  unit: 'Bpm',
  points: [ChartPoint(x: 0, y: 0), ChartPoint(x: 1, y: 40)],
  xLabels: ['4/6', '1/7'],
  referenceValue: 60,
  referenceStart: 0.3,
  levelTitle: 'Declining',
  levelCaption: '01/07',
  segments: [TrainingLevel.veryPoor],
  legend: [TrainingLevel.veryPoor],
  marker: 0.2,
);

class _Repo implements TrainingIndexRepository {
  _Repo(this.result);

  final Either<Failure, TrainingIndexOverview> result;
  TrainingIndexKind? requested;

  @override
  Future<Either<Failure, TrainingIndexOverview>> getTrainingIndex(
    TrainingIndexKind kind,
  ) async {
    requested = kind;
    return result;
  }
}

void main() {
  test('loads the requested kind on the Day tab', () async {
    final repo = _Repo(const Right(_overview));
    final cubit = TrainingIndexCubit(GetTrainingIndexUseCase(repo));
    await cubit.loadData(TrainingIndexKind.vo2Max);
    expect(repo.requested, TrainingIndexKind.vo2Max);
    expect(cubit.state, const TrainingIndexLoaded(_overview));
    await cubit.close();
  });

  test('selectPeriod switches the tab', () async {
    final cubit = TrainingIndexCubit(
      GetTrainingIndexUseCase(_Repo(const Right(_overview))),
    );
    await cubit.loadData(TrainingIndexKind.fitnessCondition);
    cubit.selectPeriod(TrainingIndexPeriod.month);
    expect(
      cubit.state,
      const TrainingIndexLoaded(_overview, period: TrainingIndexPeriod.month),
    );
    await cubit.close();
  });

  test('emits error on failure', () async {
    final cubit = TrainingIndexCubit(
      GetTrainingIndexUseCase(_Repo(const Left(UnexpectedFailure('x')))),
    );
    await cubit.loadData(TrainingIndexKind.fitnessCondition);
    expect(cubit.state, const TrainingIndexError('x'));
    await cubit.close();
  });
}
