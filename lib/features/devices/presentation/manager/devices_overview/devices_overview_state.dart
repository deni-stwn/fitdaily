import 'package:equatable/equatable.dart';

import '../../../domain/entities/devices_overview.dart';

abstract class DevicesOverviewState extends Equatable {
  const DevicesOverviewState();

  @override
  List<Object?> get props => [];
}

class DevicesOverviewInitial extends DevicesOverviewState {}

class DevicesOverviewLoading extends DevicesOverviewState {}

class DevicesOverviewLoaded extends DevicesOverviewState {
  final DevicesOverview overview;

  const DevicesOverviewLoaded(this.overview);

  @override
  List<Object?> get props => [overview];
}

class DevicesOverviewError extends DevicesOverviewState {
  final String message;

  const DevicesOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}
