import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/activity_overview.dart';

abstract class ActivityRepository {
  Future<Either<Failure, ActivityOverview>> getOverview();
}
