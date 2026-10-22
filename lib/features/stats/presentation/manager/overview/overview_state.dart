import 'package:equatable/equatable.dart';

import '../../../domain/entities/metric_overview.dart';

abstract class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object?> get props => [];
}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewLoaded extends OverviewState {
  const OverviewLoaded(
    this.overview, {
    this.period = OverviewPeriod.day,
    required this.selected,
  });

  final MetricOverview overview;
  final OverviewPeriod period;

  /// Selected summary bar of [period].
  final int selected;

  OverviewPeriodData get data => overview.periods[period]!;
  OverviewBar get bar => data.bars[selected];

  OverviewLoaded copyWith({OverviewPeriod? period, int? selected}) =>
      OverviewLoaded(
        overview,
        period: period ?? this.period,
        selected: selected ?? this.selected,
      );

  @override
  List<Object?> get props => [overview, period, selected];
}

class OverviewError extends OverviewState {
  const OverviewError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
