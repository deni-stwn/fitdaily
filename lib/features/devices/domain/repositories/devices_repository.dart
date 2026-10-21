import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/device_entity.dart';

abstract class DevicesRepository {
  Future<Either<Failure, List<DeviceEntity>>> getDevices();
}
