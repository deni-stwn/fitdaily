import '../../core/di/injection_container.dart';
import 'data/datasources/settings_local_data_source.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/usecases/get_settings_usecase.dart';
import 'domain/usecases/save_settings_usecase.dart';
import 'presentation/manager/settings/settings_cubit.dart';

void initSettings() {
  // ── State Management ────────────────────────────────────────────────────────
  sl.registerFactory(
    () => SettingsCubit(sl<GetSettingsUseCase>(), sl<SaveSettingsUseCase>()),
  );

  // ── Use Cases ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetSettingsUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => SaveSettingsUseCase(sl<SettingsRepository>()));

  // ── Repository ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl<SettingsLocalDataSource>()),
  );

  // ── Data Sources (singleton: keeps saved values in memory) ──────────────────
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(),
  );
}
