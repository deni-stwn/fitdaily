import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/entities/device_entity.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/repositories/devices_repository.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/usecases/get_devices_usecase.dart';
import 'package:flutter_clean_architecture_template/features/devices/presentation/manager/device/device_cubit.dart';
import 'package:flutter_clean_architecture_template/features/devices/presentation/manager/device/device_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements DevicesRepository {
  @override
  Future<Either<Failure, List<DeviceEntity>>> getDevices() async =>
      const Right([
        DeviceEntity(id: '1', name: 'Watch', image: '', connected: true),
        DeviceEntity(id: '2', name: 'Watch', image: '', connected: false),
      ]);
}

void main() {
  test('loads devices and toggles connection', () async {
    final cubit = DeviceCubit(GetDevicesUseCase(_FakeRepository()));
    await cubit.loadData();
    expect(cubit.state, isA<DeviceLoaded>());

    cubit.toggleConnection('2');
    final items = (cubit.state as DeviceLoaded).items;
    expect(items.map((d) => d.connected), [true, true]);

    cubit.toggleConnection('1');
    expect((cubit.state as DeviceLoaded).items.first.connected, isFalse);
    await cubit.close();
  });
}
