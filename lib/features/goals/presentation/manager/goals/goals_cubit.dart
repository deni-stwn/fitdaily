import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/entities/goals_overview.dart';
import '../../../domain/usecases/get_goals_overview_usecase.dart';
import 'goals_state.dart';

class GoalsCubit extends Cubit<GoalsState>
    with CancelableSafeCubitMixin<GoalsState> {
  GoalsCubit(this._getOverview) : super(GoalsInitial());

  final GetGoalsOverviewUseCase _getOverview;

  Future<void> loadData() async {
    safeEmit(GoalsLoading());
    final result = await runCancelable(_getOverview.call());
    if (result == null) return;
    result.fold(
      (failure) => safeEmit(GoalsError(failure.message)),
      (overview) => safeEmit(GoalsLoaded(overview)),
    );
  }

  /// Commit step "Done": appends the goal to the in-memory list.
  void addGoal(TrackedGoal goal) {
    final s = state;
    if (s is! GoalsLoaded) return;
    safeEmit(
      GoalsLoaded(s.overview.copyWith(goals: [...s.overview.goals, goal])),
    );
  }

  /// Row "⋮" menu → Delete.
  void removeGoal(int index) {
    final s = state;
    if (s is! GoalsLoaded || index < 0 || index >= s.overview.goals.length) {
      return;
    }
    safeEmit(
      GoalsLoaded(
        s.overview.copyWith(goals: [...s.overview.goals]..removeAt(index)),
      ),
    );
  }
}
