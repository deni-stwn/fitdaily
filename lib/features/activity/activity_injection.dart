import '../../core/di/injection_container.dart';
import 'data/datasources/activity_local_data_source.dart';
import 'data/repositories/activity_repository_impl.dart';
import 'domain/repositories/activity_repository.dart';
import 'domain/usecases/get_activity_overview_usecase.dart';
import 'presentation/manager/activity/activity_cubit.dart';
import 'data/datasources/training_history_local_data_source.dart';
import 'data/datasources/training_index_local_data_source.dart';
import 'data/repositories/training_history_repository_impl.dart';
import 'data/repositories/training_index_repository_impl.dart';
import 'domain/repositories/training_history_repository.dart';
import 'domain/repositories/training_index_repository.dart';
import 'domain/usecases/get_training_history_usecase.dart';
import 'domain/usecases/get_training_index_usecase.dart';
import 'presentation/manager/training_history/training_history_cubit.dart';
import 'presentation/manager/training_index/training_index_cubit.dart';
import 'data/datasources/training_local_data_source.dart';
import 'data/repositories/training_repository_impl.dart';
import 'domain/repositories/training_repository.dart';
import 'domain/usecases/get_training_setup_usecase.dart';
import 'presentation/manager/training/training_cubit.dart';

void initActivity() {
  // Fitness Condition / VO₂ Max + Training History.
  _initTrainingStats();
  // Start Training session flow.
  _initTrainingSession();

  // ── State Management ────────────────────────────────────────────────────────
  sl.registerFactory(() => ActivityCubit(sl<GetActivityOverviewUseCase>()));

  // ── Use Cases ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => GetActivityOverviewUseCase(sl<ActivityRepository>()),
  );

  // ── Repository ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(sl<ActivityLocalDataSource>()),
  );

  // ── Data Sources ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ActivityLocalDataSource>(
    () => ActivityLocalDataSourceImpl(),
  );
}

/// Fitness Condition / VO₂ Max (Training Index) and Training History.
void _initTrainingStats() {
  sl.registerFactory(() => TrainingIndexCubit(sl<GetTrainingIndexUseCase>()));
  sl.registerFactory(
    () => TrainingHistoryCubit(sl<GetTrainingHistoryUseCase>()),
  );

  sl.registerLazySingleton(
    () => GetTrainingIndexUseCase(sl<TrainingIndexRepository>()),
  );
  sl.registerLazySingleton(
    () => GetTrainingHistoryUseCase(sl<TrainingHistoryRepository>()),
  );

  sl.registerLazySingleton<TrainingIndexRepository>(
    () => TrainingIndexRepositoryImpl(sl<TrainingIndexLocalDataSource>()),
  );
  sl.registerLazySingleton<TrainingHistoryRepository>(
    () => TrainingHistoryRepositoryImpl(sl<TrainingHistoryLocalDataSource>()),
  );

  sl.registerLazySingleton<TrainingIndexLocalDataSource>(
    () => TrainingIndexLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<TrainingHistoryLocalDataSource>(
    () => TrainingHistoryLocalDataSourceImpl(),
  );
}

/// Start Training flow (Set Target → Walking Session → Target Reached).
void _initTrainingSession() {
  sl.registerFactory(() => TrainingCubit(sl<GetTrainingSetupUseCase>()));
  sl.registerLazySingleton(
    () => GetTrainingSetupUseCase(sl<TrainingRepository>()),
  );
  sl.registerLazySingleton<TrainingRepository>(
    () => TrainingRepositoryImpl(sl<TrainingLocalDataSource>()),
  );
  sl.registerLazySingleton<TrainingLocalDataSource>(
    () => TrainingLocalDataSourceImpl(),
  );
}
