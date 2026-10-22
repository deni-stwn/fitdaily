import 'package:equatable/equatable.dart';

import '../../../domain/entities/training_index.dart';

abstract class TrainingIndexState extends Equatable {
  const TrainingIndexState();

  @override
  List<Object?> get props => [];
}

class TrainingIndexInitial extends TrainingIndexState {}

class TrainingIndexLoading extends TrainingIndexState {}

class TrainingIndexLoaded extends TrainingIndexState {
  const TrainingIndexLoaded(
    this.overview, {
    this.period = TrainingIndexPeriod.day,
  });

  final TrainingIndexOverview overview;

  /// Active tab — content is the same for Day and Month (as in Figma).
  final TrainingIndexPeriod period;

  TrainingIndexLoaded copyWith({TrainingIndexPeriod? period}) =>
      TrainingIndexLoaded(overview, period: period ?? this.period);

  @override
  List<Object?> get props => [overview, period];
}

class TrainingIndexError extends TrainingIndexState {
  const TrainingIndexError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
