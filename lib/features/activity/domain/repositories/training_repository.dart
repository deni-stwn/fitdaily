import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/training_session.dart';

abstract class TrainingRepository {
  Future<Either<Failure, TrainingSetup>> getSetup();
}
