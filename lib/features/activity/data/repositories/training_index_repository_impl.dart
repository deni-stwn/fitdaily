import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/training_index.dart';
import '../../domain/repositories/training_index_repository.dart';
import '../datasources/training_index_local_data_source.dart';

class TrainingIndexRepositoryImpl implements TrainingIndexRepository {
  TrainingIndexRepositoryImpl(this.localDataSource);

  final TrainingIndexLocalDataSource localDataSource;

  @override
  Future<Either<Failure, TrainingIndexOverview>> getTrainingIndex(
    TrainingIndexKind kind,
  ) {
    return safeCall(() => localDataSource.fetchTrainingIndex(kind));
  }
}
