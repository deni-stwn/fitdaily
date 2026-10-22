import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/training_index.dart';

abstract class TrainingIndexRepository {
  Future<Either<Failure, TrainingIndexOverview>> getTrainingIndex(
    TrainingIndexKind kind,
  );
}
