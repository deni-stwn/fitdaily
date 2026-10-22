import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/goals_overview.dart';
import '../../domain/repositories/goals_repository.dart';
import '../datasources/goals_local_data_source.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  GoalsRepositoryImpl(this.localDataSource);

  final GoalsLocalDataSource localDataSource;

  @override
  Future<Either<Failure, GoalsOverview>> getOverview() {
    return safeCall(localDataSource.fetchOverview);
  }
}
