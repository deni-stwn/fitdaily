import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/heart_rate_overview.dart';
import '../../domain/entities/metric_overview.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_local_data_source.dart';

class StatsRepositoryImpl implements StatsRepository {
  StatsRepositoryImpl(this.localDataSource);

  final StatsLocalDataSource localDataSource;

  @override
  Future<Either<Failure, MetricOverview>> getOverview(OverviewMetric metric) {
    return safeCall(() => localDataSource.fetchOverview(metric));
  }

  @override
  Future<Either<Failure, HeartRateOverview>> getHeartRate() {
    return safeCall(localDataSource.fetchHeartRate);
  }
}
