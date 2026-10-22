import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/usecases/clear_notifications_usecase.dart';
import '../../../domain/usecases/get_home_dashboard_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState>
    with CancelableSafeCubitMixin<HomeState> {
  HomeCubit(this._getDashboard, [this._clearNotifications])
    : super(HomeInitial());

  final GetHomeDashboardUseCase _getDashboard;
  final ClearNotificationsUseCase? _clearNotifications;

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

  /// Notification panel "Clear All Notification" — kept for the app
  /// session so the other tabs' panels are empty too.
  void clearNotifications() {
    final current = state;
    if (current is! HomeLoaded) return;
    _clearNotifications?.call();
    safeEmit(
      current.copyWith(
        dashboard: current.dashboard.copyWith(notifications: const []),
      ),
    );
  }
}
