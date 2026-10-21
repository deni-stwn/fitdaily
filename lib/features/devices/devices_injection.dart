import '../../core/di/injection_container.dart';
import 'data/datasources/devices_local_data_source.dart';
import 'data/repositories/devices_repository_impl.dart';
import 'domain/repositories/devices_repository.dart';
import 'domain/usecases/get_devices_usecase.dart';
import 'presentation/manager/device/device_cubit.dart';

void initDevices() {
  // ── State Management ────────────────────────────────────────────────────────
  sl.registerFactory(() => DeviceCubit(sl<GetDevicesUseCase>()));

  // ── Use Cases ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetDevicesUseCase(sl<DevicesRepository>()));

  // ── Repository ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<DevicesRepository>(
    () => DevicesRepositoryImpl(sl<DevicesLocalDataSource>()),
  );

  // ── Data Sources ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<DevicesLocalDataSource>(
    () => DevicesLocalDataSourceImpl(),
  );
}
