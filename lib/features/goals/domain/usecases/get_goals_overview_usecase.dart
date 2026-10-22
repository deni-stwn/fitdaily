import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/goals_overview.dart';
import '../repositories/goals_repository.dart';

class GetGoalsOverviewUseCase implements UseCase<GoalsOverview, NoParam> {
  GetGoalsOverviewUseCase(this.repository);

  final GoalsRepository repository;

  @override
  Future<Either<Failure, GoalsOverview>> call([NoParam? param]) =>
      repository.getOverview();
}
