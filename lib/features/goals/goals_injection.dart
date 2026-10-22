import '../../core/di/injection_container.dart';
import 'data/datasources/goals_local_data_source.dart';
import 'data/repositories/goals_repository_impl.dart';
import 'domain/repositories/goals_repository.dart';
import 'domain/usecases/get_goals_overview_usecase.dart';
import 'presentation/manager/goals/goals_cubit.dart';

void initGoals() {
  // ── State Management ────────────────────────────────────────────────────────
  sl.registerFactory(() => GoalsCubit(sl<GetGoalsOverviewUseCase>()));

  // ── Use Cases ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => GetGoalsOverviewUseCase(sl<GoalsRepository>()),
  );

  // ── Repository ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<GoalsRepository>(
    () => GoalsRepositoryImpl(sl<GoalsLocalDataSource>()),
  );

  // ── Data Sources ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<GoalsLocalDataSource>(
    () => GoalsLocalDataSourceImpl(),
  );
}
