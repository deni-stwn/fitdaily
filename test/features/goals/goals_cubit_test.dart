import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/goals/domain/entities/goals_overview.dart';
import 'package:flutter_clean_architecture_template/features/goals/domain/repositories/goals_repository.dart';
import 'package:flutter_clean_architecture_template/features/goals/domain/usecases/get_goals_overview_usecase.dart';
import 'package:flutter_clean_architecture_template/features/goals/presentation/manager/goals/goals_cubit.dart';
import 'package:flutter_clean_architecture_template/features/goals/presentation/manager/goals/goals_state.dart';
import 'package:flutter_test/flutter_test.dart';

const _protein = TrackedGoal(
  name: 'Protein',
  tracking: '95/95 gram',
  status: GoalStatus.complete,
);

const _overview = GoalsOverview(
  userName: 'Brian',
  avatar: 'a.png',
  progress: 67,
  progressFill: 0.5189,
  weekly: GoalSummary(percent: 80, bars: [50, 50, 50, 50, 50, 50, 20]),
  total: GoalSummary(percent: 50, bars: [50, 50, 50, 25, 0, 0, 0]),
  goals: [_protein],
  targets: {
    GoalType.steps: ['2500 Step'],
  },
);

class _Repo implements GoalsRepository {
  _Repo(this.result);

  final Either<Failure, GoalsOverview> result;

  @override
  Future<Either<Failure, GoalsOverview>> getOverview() async => result;
}

GoalsCubit _cubit(Either<Failure, GoalsOverview> result) =>
    GoalsCubit(GetGoalsOverviewUseCase(_Repo(result)));

void main() {
  test('loads goals overview', () async {
    final cubit = _cubit(const Right(_overview));
    await cubit.loadData();
    expect(cubit.state, const GoalsLoaded(_overview));
    await cubit.close();
  });

  test('emits error on failure', () async {
    final cubit = _cubit(const Left(UnexpectedFailure('x')));
    await cubit.loadData();
    expect(cubit.state, const GoalsError('x'));
    await cubit.close();
  });

  test('addGoal appends and removeGoal deletes', () async {
    final cubit = _cubit(const Right(_overview));
    await cubit.loadData();
    const steps = TrackedGoal(
      name: 'Steps',
      tracking: '2500 Step',
      status: GoalStatus.incomplete,
    );
    cubit.addGoal(steps);
    expect((cubit.state as GoalsLoaded).overview.goals, [_protein, steps]);
    cubit.removeGoal(0);
    expect((cubit.state as GoalsLoaded).overview.goals, [steps]);
    await cubit.close();
  });
}
