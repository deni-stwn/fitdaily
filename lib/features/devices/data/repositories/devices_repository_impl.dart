import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/devices_repository.dart';
import '../datasources/devices_local_data_source.dart';

class DevicesRepositoryImpl implements DevicesRepository {
  final DevicesLocalDataSource localDataSource;

  DevicesRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<DeviceEntity>>> getDevices() {
    return safeCall(() => localDataSource.fetchDevices());
  }
}
