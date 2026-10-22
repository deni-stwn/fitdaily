import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/entities/training_history.dart';
import '../../../domain/usecases/get_training_history_usecase.dart';
import 'training_history_state.dart';

/// Training History (Daily / Monthly / Yearly). Delete only changes the
/// in-memory list (no backend).
class TrainingHistoryCubit extends Cubit<TrainingHistoryState>
    with CancelableSafeCubitMixin<TrainingHistoryState> {
  TrainingHistoryCubit(this._getHistory) : super(TrainingHistoryInitial());

  final GetTrainingHistoryUseCase _getHistory;

  Future<void> loadData({HistoryPeriod period = HistoryPeriod.day}) async {
    safeEmit(TrainingHistoryLoading());
    final result = await runCancelable(_getHistory.call());
    if (result == null) return;
    result.fold(
      (failure) => safeEmit(TrainingHistoryError(failure.message)),
      (history) => safeEmit(TrainingHistoryLoaded(history, period: period)),
    );
  }

  /// Day / Month / Year tab.
  void selectPeriod(HistoryPeriod period) {
    final current = state;
    if (current is TrainingHistoryLoaded && current.period != period) {
      safeEmit(current.copyWith(period: period));
    }
  }

  /// Removes the record [id] from every tab.
  void deleteRecord(String id) {
    final current = state;
    if (current is TrainingHistoryLoaded) {
      safeEmit(current.copyWith(history: current.history.without(id)));
    }
  }
}
