import '../../core/di/injection_container.dart';
import 'data/datasources/home_local_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_home_dashboard_usecase.dart';
import 'presentation/manager/home/home_cubit.dart';

void initHome() {
  // ── State Management ────────────────────────────────────────────────────────
  sl.registerFactory(() => HomeCubit(sl<GetHomeDashboardUseCase>()));

  // ── Use Cases ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetHomeDashboardUseCase(sl<HomeRepository>()));

  // ── Repository ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeLocalDataSource>()),
  );

  // ── Data Sources ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );
}
