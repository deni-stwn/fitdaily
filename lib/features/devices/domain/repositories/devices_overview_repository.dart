import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/devices_overview.dart';

/// Devices tab (683:53253) and FAQ (683:54678). Kept apart from
/// [DevicesRepository] so the Device Setup scan stays unchanged.
abstract class DevicesOverviewRepository {
  Future<Either<Failure, DevicesOverview>> getOverview();

  Future<Either<Failure, List<FaqItem>>> getFaqs();
}
