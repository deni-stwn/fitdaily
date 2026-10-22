import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/home_dashboard.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this.localDataSource);

  final HomeLocalDataSource localDataSource;

  @override
  Future<Either<Failure, HomeDashboard>> getDashboard() {
    return safeCall(() => localDataSource.fetchDashboard());
  }

  @override
  Future<Either<Failure, Unit>> clearNotifications() {
    return safeCall(() async {
      localDataSource.clearNotifications();
      return unit;
    });
  }
}
