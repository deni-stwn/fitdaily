import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/activity_overview.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_local_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl(this.localDataSource);

  final ActivityLocalDataSource localDataSource;

  @override
  Future<Either<Failure, ActivityOverview>> getOverview() {
    return safeCall(localDataSource.fetchOverview);
  }
}
