import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/usecases/get_activity_overview_usecase.dart';
import 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState>
    with CancelableSafeCubitMixin<ActivityState> {
  ActivityCubit(this._getOverview) : super(ActivityInitial());

  final GetActivityOverviewUseCase _getOverview;

  Future<void> loadData() async {
    safeEmit(ActivityLoading());
    final result = await runCancelable(_getOverview.call());
    if (result == null) return;
    result.fold(
      (failure) => safeEmit(ActivityError(failure.message)),
      (overview) => safeEmit(ActivityLoaded(overview)),
    );
  }
}
