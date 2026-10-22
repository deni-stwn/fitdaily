import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/entities/metric_overview.dart';
import '../../../domain/usecases/get_heart_rate_overview_usecase.dart';
import 'heart_rate_state.dart';

class HeartRateCubit extends Cubit<HeartRateState>
    with CancelableSafeCubitMixin<HeartRateState> {
  HeartRateCubit(this._getHeartRate) : super(HeartRateInitial());

  final GetHeartRateOverviewUseCase _getHeartRate;

  Future<void> loadData() async {
    safeEmit(HeartRateLoading());
    final result = await runCancelable(_getHeartRate.call());
    if (result == null) return;
    result.fold(
      (failure) => safeEmit(HeartRateError(failure.message)),
      (overview) => safeEmit(HeartRateLoaded(overview)),
    );
  }

  /// Day / Month / Year tab.
  void selectPeriod(OverviewPeriod period) {
    final current = state;
    if (current is HeartRateLoaded && current.period != period) {
      safeEmit(current.copyWith(period: period));
    }
  }
}
