import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/entities/metric_overview.dart';
import '../../../domain/usecases/get_metric_overview_usecase.dart';
import 'overview_state.dart';

class OverviewCubit extends Cubit<OverviewState>
    with CancelableSafeCubitMixin<OverviewState> {
  OverviewCubit(this._getOverview) : super(OverviewInitial());

  final GetMetricOverviewUseCase _getOverview;

  Future<void> loadData(OverviewMetric metric) async {
    safeEmit(OverviewLoading());
    final result = await runCancelable(_getOverview.call(metric));
    if (result == null) return;
    result.fold(
      (failure) => safeEmit(OverviewError(failure.message)),
      (overview) => safeEmit(
        OverviewLoaded(
          overview,
          selected: overview.periods[OverviewPeriod.day]!.selected,
        ),
      ),
    );
  }

  /// Day / Month / Year tab — resets to the period's default bar.
  void selectPeriod(OverviewPeriod period) {
    final current = state;
    if (current is! OverviewLoaded || current.period == period) return;
    safeEmit(
      current.copyWith(
        period: period,
        selected: current.overview.periods[period]!.selected,
      ),
    );
  }

  /// Summary bar tap.
  void selectBar(int index) {
    final current = state;
    if (current is OverviewLoaded) safeEmit(current.copyWith(selected: index));
  }
}
