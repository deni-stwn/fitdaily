import 'package:equatable/equatable.dart';

import '../../../domain/entities/heart_rate_overview.dart';
import '../../../domain/entities/metric_overview.dart';

abstract class HeartRateState extends Equatable {
  const HeartRateState();

  @override
  List<Object?> get props => [];
}

class HeartRateInitial extends HeartRateState {}

class HeartRateLoading extends HeartRateState {}

class HeartRateLoaded extends HeartRateState {
  const HeartRateLoaded(this.overview, {this.period = OverviewPeriod.day});

  final HeartRateOverview overview;

  /// Active tab — content is the same for every period (as in Figma).
  final OverviewPeriod period;

  HeartRateLoaded copyWith({OverviewPeriod? period}) =>
      HeartRateLoaded(overview, period: period ?? this.period);

  @override
  List<Object?> get props => [overview, period];
}

class HeartRateError extends HeartRateState {
  const HeartRateError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
