import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/heart_rate_overview.dart';
import '../repositories/stats_repository.dart';

class GetHeartRateOverviewUseCase
    implements UseCase<HeartRateOverview, NoParam> {
  GetHeartRateOverviewUseCase(this.repository);

  final StatsRepository repository;

  @override
  Future<Either<Failure, HeartRateOverview>> call([NoParam? param]) =>
      repository.getHeartRate();
}
