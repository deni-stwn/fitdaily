import 'package:equatable/equatable.dart';

import '../../../domain/entities/activity_overview.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  const ActivityLoaded(this.overview);

  final ActivityOverview overview;

  @override
  List<Object?> get props => [overview];
}

class ActivityError extends ActivityState {
  const ActivityError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
