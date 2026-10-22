import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/entities/devices_overview.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/repositories/devices_overview_repository.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/usecases/get_devices_overview_usecase.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/usecases/get_faqs_usecase.dart';
import 'package:flutter_clean_architecture_template/features/devices/presentation/manager/devices_overview/devices_overview_cubit.dart';
import 'package:flutter_clean_architecture_template/features/devices/presentation/manager/devices_overview/devices_overview_state.dart';
import 'package:flutter_clean_architecture_template/features/devices/presentation/manager/faq/faq_cubit.dart';
import 'package:flutter_clean_architecture_template/features/devices/presentation/manager/faq/faq_state.dart';
import 'package:flutter_test/flutter_test.dart';

UserDevice _device(String id, DeviceConnection connection) => UserDevice(
  id: id,
  name: 'Watch',
  image: '',
  connection: connection,
  synced: true,
  lastSync: '12:09',
  deviceId: 'ZX47-9Q2L',
  deviceName: 'Brian’s Watch',
  battery: 85,
);

class _FakeRepository implements DevicesOverviewRepository {
  @override
  Future<Either<Failure, DevicesOverview>> getOverview() async => Right(
    DevicesOverview(
      userName: 'Brian',
      avatar: '',
      paired: [_device('p1', DeviceConnection.connected)],
      nearby: [
        _device('n1', DeviceConnection.connected),
        _device('n2', DeviceConnection.connecting),
      ],
    ),
  );

  @override
  Future<Either<Failure, List<FaqItem>>> getFaqs() async => const Right([
    FaqItem(
      id: 'a',
      question: 'How does the app connect to wearables?',
      answer: 'Restart it.',
    ),
    FaqItem(
      id: 'b',
      question: 'How does the app track calories burned?',
      answer: 'Heart rate.',
    ),
  ]);
}

void main() {
  test('loads overview, unbinds and forgets a device', () async {
    final cubit = DevicesOverviewCubit(
      GetDevicesOverviewUseCase(_FakeRepository()),
    );
    await cubit.loadData();
    expect(cubit.state, isA<DevicesOverviewLoaded>());

    cubit.unbind('n1');
    var overview = (cubit.state as DevicesOverviewLoaded).overview;
    expect(overview.nearby.first.connection, DeviceConnection.disconnected);

    cubit.forget('p1');
    overview = (cubit.state as DevicesOverviewLoaded).overview;
    expect(overview.paired, isEmpty);
    expect(overview.nearby, hasLength(2));
    await cubit.close();
  });

  test('FAQ opens the first topic, toggles and filters', () async {
    final cubit = FaqCubit(GetFaqsUseCase(_FakeRepository()));
    await cubit.loadData();
    var state = cubit.state as FaqLoaded;
    expect(state.expanded, {'a'});

    cubit.toggle('a');
    cubit.toggle('b');
    state = cubit.state as FaqLoaded;
    expect(state.expanded, {'b'});

    cubit.search('CALORIES');
    state = cubit.state as FaqLoaded;
    expect(state.visible.map((e) => e.id), ['b']);
    await cubit.close();
  });
}
