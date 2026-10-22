import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/heart_rate_overview.dart';
import '../entities/metric_overview.dart';

abstract class StatsRepository {
  Future<Either<Failure, MetricOverview>> getOverview(OverviewMetric metric);

  Future<Either<Failure, HeartRateOverview>> getHeartRate();
}
