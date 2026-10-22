import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/entities/training_index.dart';
import '../../../domain/usecases/get_training_index_usecase.dart';
import 'training_index_state.dart';

/// Fitness Condition / VO₂ Max screens.
class TrainingIndexCubit extends Cubit<TrainingIndexState>
    with CancelableSafeCubitMixin<TrainingIndexState> {
  TrainingIndexCubit(this._getTrainingIndex) : super(TrainingIndexInitial());

  final GetTrainingIndexUseCase _getTrainingIndex;

  Future<void> loadData(
    TrainingIndexKind kind, {
    TrainingIndexPeriod period = TrainingIndexPeriod.day,
  }) async {
    safeEmit(TrainingIndexLoading());
    final result = await runCancelable(_getTrainingIndex.call(kind));
    if (result == null) return;
    result.fold(
      (failure) => safeEmit(TrainingIndexError(failure.message)),
      (overview) => safeEmit(TrainingIndexLoaded(overview, period: period)),
    );
  }

  /// Day / Month tab.
  void selectPeriod(TrainingIndexPeriod period) {
    final current = state;
    if (current is TrainingIndexLoaded && current.period != period) {
      safeEmit(current.copyWith(period: period));
    }
  }
}
