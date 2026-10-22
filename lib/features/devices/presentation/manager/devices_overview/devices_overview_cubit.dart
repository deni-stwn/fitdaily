import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/entities/devices_overview.dart';
import '../../../domain/usecases/get_devices_overview_usecase.dart';
import 'devices_overview_state.dart';

/// Devices tab (683:53253) + detail sheet actions (703:12420).
class DevicesOverviewCubit extends Cubit<DevicesOverviewState>
    with CancelableSafeCubitMixin<DevicesOverviewState> {
  final GetDevicesOverviewUseCase _getOverview;

  DevicesOverviewCubit(this._getOverview) : super(DevicesOverviewInitial());

  Future<void> loadData() async {
    safeEmit(DevicesOverviewLoading());

    final result = await runCancelable(_getOverview.call());

    if (result == null) return;

    result.fold(
      (failure) => safeEmit(DevicesOverviewError(failure.message)),
      (overview) => safeEmit(DevicesOverviewLoaded(overview)),
    );
  }

  /// "Unbind" (dummy): the device stays listed as Not Connected.
  void unbind(String id) => _update(
    (devices) => [
      for (final d in devices)
        d.id == id ? d.copyWith(connection: DeviceConnection.disconnected) : d,
    ],
  );

  /// "Forget Device" (dummy): removes the device from the tab.
  void forget(String id) =>
      _update((devices) => [...devices.where((d) => d.id != id)]);

  void _update(List<UserDevice> Function(List<UserDevice>) change) {
    final current = state;
    if (current is! DevicesOverviewLoaded) return;
    final overview = current.overview;
    safeEmit(
      DevicesOverviewLoaded(
        overview.copyWith(
          paired: change(overview.paired),
          nearby: change(overview.nearby),
        ),
      ),
    );
  }
}
