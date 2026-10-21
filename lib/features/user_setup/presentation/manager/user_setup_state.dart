import 'package:equatable/equatable.dart';

import 'setup_goal.dart';

class UserSetupState extends Equatable {
  const UserSetupState({
    this.permissions = const {SetupPermission.notifications},
    this.allPermissions = true,
    this.goals = const {
      SetupGoal.stayActive,
      SetupGoal.reduceStress,
      SetupGoal.beConsistent,
    },
  });

  /// Defaults mirror the Figma screens.
  final Set<SetupPermission> permissions;
  final bool allPermissions;
  final Set<SetupGoal> goals;

  UserSetupState copyWith({
    Set<SetupPermission>? permissions,
    bool? allPermissions,
    Set<SetupGoal>? goals,
  }) {
    return UserSetupState(
      permissions: permissions ?? this.permissions,
      allPermissions: allPermissions ?? this.allPermissions,
      goals: goals ?? this.goals,
    );
  }

  @override
  List<Object?> get props => [permissions, allPermissions, goals];
}
