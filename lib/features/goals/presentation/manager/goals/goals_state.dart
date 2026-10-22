import 'package:equatable/equatable.dart';

import '../../../domain/entities/goals_overview.dart';

abstract class GoalsState extends Equatable {
  const GoalsState();

  @override
  List<Object?> get props => [];
}

class GoalsInitial extends GoalsState {}

class GoalsLoading extends GoalsState {}

class GoalsLoaded extends GoalsState {
  const GoalsLoaded(this.overview);

  final GoalsOverview overview;

  @override
  List<Object?> get props => [overview];
}

class GoalsError extends GoalsState {
  const GoalsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
