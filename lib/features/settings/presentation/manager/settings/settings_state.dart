import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_settings.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

/// [settings] is the draft being edited on a settings page.
class SettingsLoaded extends SettingsState {
  const SettingsLoaded(this.settings);

  final UserSettings settings;

  @override
  List<Object?> get props => [settings];
}

class SettingsError extends SettingsState {
  const SettingsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
