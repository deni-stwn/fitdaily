import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/training_history.dart';
import '../../domain/repositories/training_history_repository.dart';
import '../datasources/training_history_local_data_source.dart';

class TrainingHistoryRepositoryImpl implements TrainingHistoryRepository {
  TrainingHistoryRepositoryImpl(this.localDataSource);

  final TrainingHistoryLocalDataSource localDataSource;

  @override
  Future<Either<Failure, TrainingHistory>> getHistory() {
    return safeCall(localDataSource.fetchHistory);
  }
}
