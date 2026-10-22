import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/metric_overview.dart';
import '../repositories/stats_repository.dart';

class GetMetricOverviewUseCase
    implements UseCase<MetricOverview, OverviewMetric> {
  GetMetricOverviewUseCase(this.repository);

  final StatsRepository repository;

  @override
  Future<Either<Failure, MetricOverview>> call([
    OverviewMetric metric = OverviewMetric.steps,
  ]) => repository.getOverview(metric);
}
