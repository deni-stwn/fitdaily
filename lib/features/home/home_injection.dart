import '../../core/di/injection_container.dart';
import 'data/datasources/home_local_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_product_usecase.dart';
import 'presentation/manager/product/product_cubit.dart';

void initHome() async {
  // State Management
  sl.registerFactory(() => ProductCubit(sl<GetProductUseCase>()));

  // Use Cases
  sl.registerLazySingleton(() => GetProductUseCase(sl()));

  // Data Sources
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(localDataSource: sl<HomeLocalDataSource>()),
  );
}
