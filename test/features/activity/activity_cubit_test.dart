import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/entities/activity_overview.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/entities/training_index.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/repositories/activity_repository.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/usecases/get_activity_overview_usecase.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/manager/activity/activity_cubit.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/manager/activity/activity_state.dart';
import 'package:flutter_test/flutter_test.dart';

const _overview = ActivityOverview(
  userName: 'Brian',
  avatar: 'a.png',
  history: [
    TrainingRecord(
      type: TrainingType.running,
      title: 'Running',
      duration: '40m 15s',
      calories: '3400 cal',
      date: '10 July',
      distance: '12',
      unit: 'km',
    ),
  ],
  trainingIndex: [
    TrainingIndexSummary(
      kind: TrainingIndexKind.vo2Max,
      title: 'VO₂ Max',
      value: '39',
      caption: '7 July Fair',
      marker: 0.35,
      minLabel: 'Very Poor',
      maxLabel: 'Superior',
    ),
  ],
);

class _Repo implements ActivityRepository {
  _Repo(this.result);

  final Either<Failure, ActivityOverview> result;

  @override
  Future<Either<Failure, ActivityOverview>> getOverview() async => result;
}

void main() {
  test('loads activity overview', () async {
    final cubit = ActivityCubit(
      GetActivityOverviewUseCase(_Repo(const Right(_overview))),
    );
    await cubit.loadData();
    expect(cubit.state, const ActivityLoaded(_overview));
    await cubit.close();
  });

  test('emits error on failure', () async {
    final cubit = ActivityCubit(
      GetActivityOverviewUseCase(_Repo(const Left(UnexpectedFailure('x')))),
    );
    await cubit.loadData();
    expect(cubit.state, const ActivityError('x'));
    await cubit.close();
  });
}
