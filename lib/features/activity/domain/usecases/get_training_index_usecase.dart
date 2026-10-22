import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/training_index.dart';
import '../repositories/training_index_repository.dart';

class GetTrainingIndexUseCase
    implements UseCase<TrainingIndexOverview, TrainingIndexKind> {
  GetTrainingIndexUseCase(this.repository);

  final TrainingIndexRepository repository;

  @override
  Future<Either<Failure, TrainingIndexOverview>> call([
    TrainingIndexKind kind = TrainingIndexKind.fitnessCondition,
  ]) => repository.getTrainingIndex(kind);
}
