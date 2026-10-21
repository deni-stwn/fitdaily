import 'package:equatable/equatable.dart';

import '../../../domain/entities/home_dashboard.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded(this.dashboard, {this.showQuote = true});

  final HomeDashboard dashboard;
  final bool showQuote;

  HomeLoaded copyWith({HomeDashboard? dashboard, bool? showQuote}) =>
      HomeLoaded(
        dashboard ?? this.dashboard,
        showQuote: showQuote ?? this.showQuote,
      );

  @override
  List<Object?> get props => [dashboard, showQuote];
}

class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
