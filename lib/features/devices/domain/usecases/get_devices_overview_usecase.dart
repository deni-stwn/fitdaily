import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/devices_overview.dart';
import '../repositories/devices_overview_repository.dart';

class GetDevicesOverviewUseCase implements UseCase<DevicesOverview, NoParam> {
  final DevicesOverviewRepository repository;

  GetDevicesOverviewUseCase(this.repository);

  @override
  Future<Either<Failure, DevicesOverview>> call([NoParam? param]) {
    return repository.getOverview();
  }
}
