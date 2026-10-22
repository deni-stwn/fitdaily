import 'package:equatable/equatable.dart';

import '../../../domain/entities/training_history.dart';

abstract class TrainingHistoryState extends Equatable {
  const TrainingHistoryState();

  @override
  List<Object?> get props => [];
}

class TrainingHistoryInitial extends TrainingHistoryState {}

class TrainingHistoryLoading extends TrainingHistoryState {}

class TrainingHistoryLoaded extends TrainingHistoryState {
  const TrainingHistoryLoaded(this.history, {this.period = HistoryPeriod.day});

  final TrainingHistory history;
  final HistoryPeriod period;

  /// Items of the active tab.
  List<HistoryRecord> get records => history.of(period);

  TrainingHistoryLoaded copyWith({
    TrainingHistory? history,
    HistoryPeriod? period,
  }) => TrainingHistoryLoaded(
    history ?? this.history,
    period: period ?? this.period,
  );

  @override
  List<Object?> get props => [history, period];
}

class TrainingHistoryError extends TrainingHistoryState {
  const TrainingHistoryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
