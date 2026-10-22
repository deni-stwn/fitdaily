import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/goals_overview.dart';

abstract class GoalsRepository {
  Future<Either<Failure, GoalsOverview>> getOverview();
}
