import '../../core/di/injection_container.dart';
import 'data/datasources/stats_local_data_source.dart';
import 'data/repositories/stats_repository_impl.dart';
import 'domain/repositories/stats_repository.dart';
import 'domain/usecases/get_heart_rate_overview_usecase.dart';
import 'domain/usecases/get_metric_overview_usecase.dart';
import 'presentation/manager/heart_rate/heart_rate_cubit.dart';
import 'presentation/manager/overview/overview_cubit.dart';

void initStats() {
  // ── State Management ────────────────────────────────────────────────────────
  sl.registerFactory(() => OverviewCubit(sl<GetMetricOverviewUseCase>()));
  sl.registerFactory(() => HeartRateCubit(sl<GetHeartRateOverviewUseCase>()));

  // ── Use Cases ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => GetMetricOverviewUseCase(sl<StatsRepository>()),
  );
  sl.registerLazySingleton(
    () => GetHeartRateOverviewUseCase(sl<StatsRepository>()),
  );

  // ── Repository ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<StatsRepository>(
    () => StatsRepositoryImpl(sl<StatsLocalDataSource>()),
  );

  // ── Data Sources ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<StatsLocalDataSource>(
    () => StatsLocalDataSourceImpl(),
  );
}
