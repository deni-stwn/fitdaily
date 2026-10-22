import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/devices_overview.dart';
import '../../domain/repositories/devices_overview_repository.dart';
import '../datasources/devices_local_data_source.dart';

class DevicesOverviewRepositoryImpl implements DevicesOverviewRepository {
  final DevicesLocalDataSource localDataSource;

  DevicesOverviewRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, DevicesOverview>> getOverview() {
    return safeCall(() => localDataSource.fetchOverview());
  }

  @override
  Future<Either<Failure, List<FaqItem>>> getFaqs() {
    return safeCall(() => localDataSource.fetchFaqs());
  }
}
