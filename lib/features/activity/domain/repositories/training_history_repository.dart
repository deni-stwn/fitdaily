import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/training_history.dart';

abstract class TrainingHistoryRepository {
  Future<Either<Failure, TrainingHistory>> getHistory();
}
