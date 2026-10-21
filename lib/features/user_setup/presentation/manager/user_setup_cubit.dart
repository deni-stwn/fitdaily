import 'package:flutter_bloc/flutter_bloc.dart';

import 'setup_goal.dart';
import 'user_setup_state.dart';

/// In-memory state of the User Setup flow (no backend).
class UserSetupCubit extends Cubit<UserSetupState> {
  UserSetupCubit() : super(const UserSetupState());

  void togglePermission(SetupPermission permission) {
    final permissions = {...state.permissions};
    if (!permissions.remove(permission)) permissions.add(permission);
    emit(state.copyWith(permissions: permissions));
  }

  /// "Select all" toggle: ON selects every permission, OFF clears them.
  void setAllPermissions(bool value) {
    emit(
      state.copyWith(
        allPermissions: value,
        permissions: value ? SetupPermission.values.toSet() : {},
      ),
    );
  }

  void toggleGoal(SetupGoal goal) {
    final goals = {...state.goals};
    if (!goals.remove(goal)) goals.add(goal);
    emit(state.copyWith(goals: goals));
  }

  /// Detail route of the next selected goal after [current] (or the first
  /// one when null); null when the flow is finished.
  String? nextRoute([SetupGoal? current]) {
    final start = current == null ? 0 : current.index + 1;
    for (final goal in SetupGoal.values.skip(start)) {
      if (state.goals.contains(goal) && goal.route != null) return goal.route;
    }
    return null;
  }

  bool isLast(SetupGoal current) => nextRoute(current) == null;
}
