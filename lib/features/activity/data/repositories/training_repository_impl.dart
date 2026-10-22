import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/training_session.dart';
import '../../domain/repositories/training_repository.dart';
import '../datasources/training_local_data_source.dart';

class TrainingRepositoryImpl implements TrainingRepository {
  TrainingRepositoryImpl(this.localDataSource);

  final TrainingLocalDataSource localDataSource;

  @override
  Future<Either<Failure, TrainingSetup>> getSetup() {
    return safeCall(localDataSource.fetchSetup);
  }
}
