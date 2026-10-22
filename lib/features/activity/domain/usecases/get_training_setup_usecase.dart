import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/training_session.dart';
import '../repositories/training_repository.dart';

class GetTrainingSetupUseCase implements UseCase<TrainingSetup, NoParam> {
  GetTrainingSetupUseCase(this.repository);

  final TrainingRepository repository;

  @override
  Future<Either<Failure, TrainingSetup>> call([NoParam? param]) =>
      repository.getSetup();
}
