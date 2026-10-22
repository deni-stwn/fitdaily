import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/activity_overview.dart';
import '../repositories/activity_repository.dart';

class GetActivityOverviewUseCase implements UseCase<ActivityOverview, NoParam> {
  GetActivityOverviewUseCase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, ActivityOverview>> call([NoParam? param]) =>
      repository.getOverview();
}
