import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/training_history.dart';
import '../repositories/training_history_repository.dart';

class GetTrainingHistoryUseCase implements UseCase<TrainingHistory, NoParam> {
  GetTrainingHistoryUseCase(this.repository);

  final TrainingHistoryRepository repository;

  @override
  Future<Either<Failure, TrainingHistory>> call([NoParam? param]) =>
      repository.getHistory();
}
