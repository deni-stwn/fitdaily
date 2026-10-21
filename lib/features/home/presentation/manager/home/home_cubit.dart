import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/usecases/get_home_dashboard_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState>
    with CancelableSafeCubitMixin<HomeState> {
  HomeCubit(this._getDashboard) : super(HomeInitial());

  final GetHomeDashboardUseCase _getDashboard;

  Future<void> loadData() async {
    safeEmit(HomeLoading());
    final result = await runCancelable(_getDashboard.call());
    if (result == null) return;
    result.fold(
      (failure) => safeEmit(HomeError(failure.message)),
      (dashboard) => safeEmit(HomeLoaded(dashboard)),
    );
  }

  /// Quote card "X".
  void dismissQuote() {
    final current = state;
    if (current is HomeLoaded) safeEmit(current.copyWith(showQuote: false));
  }

  /// Notification panel "Clear All Notification".
  void clearNotifications() {
    final current = state;
    if (current is! HomeLoaded) return;
    safeEmit(
      current.copyWith(
        dashboard: current.dashboard.copyWith(notifications: const []),
      ),
    );
  }
}
