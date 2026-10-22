import '../../core/di/injection_container.dart';
import 'data/datasources/devices_local_data_source.dart';
import 'data/repositories/devices_overview_repository_impl.dart';
import 'data/repositories/devices_repository_impl.dart';
import 'domain/repositories/devices_overview_repository.dart';
import 'domain/repositories/devices_repository.dart';
import 'domain/usecases/get_devices_overview_usecase.dart';
import 'domain/usecases/get_devices_usecase.dart';
import 'domain/usecases/get_faqs_usecase.dart';
import 'presentation/manager/device/device_cubit.dart';
import 'presentation/manager/devices_overview/devices_overview_cubit.dart';
import 'presentation/manager/faq/faq_cubit.dart';

void initDevices() {
  // ── State Management ────────────────────────────────────────────────────────
  sl.registerFactory(() => DeviceCubit(sl<GetDevicesUseCase>()));
  sl.registerFactory(
    () => DevicesOverviewCubit(sl<GetDevicesOverviewUseCase>()),
  );
  sl.registerFactory(() => FaqCubit(sl<GetFaqsUseCase>()));

  // ── Use Cases ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetDevicesUseCase(sl<DevicesRepository>()));
  sl.registerLazySingleton(
    () => GetDevicesOverviewUseCase(sl<DevicesOverviewRepository>()),
  );
  sl.registerLazySingleton(
    () => GetFaqsUseCase(sl<DevicesOverviewRepository>()),
  );

  // ── Repository ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<DevicesRepository>(
    () => DevicesRepositoryImpl(sl<DevicesLocalDataSource>()),
  );
  sl.registerLazySingleton<DevicesOverviewRepository>(
    () => DevicesOverviewRepositoryImpl(sl<DevicesLocalDataSource>()),
  );

  // ── Data Sources ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<DevicesLocalDataSource>(
    () => DevicesLocalDataSourceImpl(),
  );
}
