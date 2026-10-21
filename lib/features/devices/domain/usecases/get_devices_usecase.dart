import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/device_entity.dart';
import '../repositories/devices_repository.dart';

class GetDevicesUseCase implements UseCase<List<DeviceEntity>, NoParam> {
  final DevicesRepository repository;

  GetDevicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<DeviceEntity>>> call([NoParam? param]) async {
    return repository.getDevices();
  }
}
