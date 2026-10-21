import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/usecases/get_devices_usecase.dart';
import 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState>
    with CancelableSafeCubitMixin<DeviceState> {
  final GetDevicesUseCase _getDevicesUseCase;

  DeviceCubit(this._getDevicesUseCase) : super(DeviceInitial());

  Future<void> loadData() async {
    safeEmit(DeviceLoading());

    final result = await runCancelable(_getDevicesUseCase.call());

    if (result == null) return;

    result.fold(
      (failure) => safeEmit(DeviceError(failure.message)),
      (items) => safeEmit(DeviceLoaded(items)),
    );
  }

  /// Dummy pairing: tapping a device toggles Connected / Not Connected.
  void toggleConnection(String id) {
    final current = state;
    if (current is! DeviceLoaded) return;
    safeEmit(
      DeviceLoaded([
        for (final device in current.items)
          device.id == id
              ? device.copyWith(connected: !device.connected)
              : device,
      ]),
    );
  }
}
