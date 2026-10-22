import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../domain/entities/goals_overview.dart';

/// Icon + texts of the Create Goals list (683:53393).
extension GoalTypeUi on GoalType {
  String get icon => switch (this) {
    GoalType.steps => 'assets/icons/goal_steps.svg',
    GoalType.water => 'assets/icons/goal_water.svg',
    GoalType.calories => 'assets/icons/goal_calories.svg',
    GoalType.sleep => 'assets/icons/goal_sleep.svg',
    GoalType.stress => 'assets/icons/goal_stress.svg',
  };

  String get titleKey => switch (this) {
    GoalType.steps => LocaleKeys.goals_steps,
    GoalType.water => LocaleKeys.goals_water,
    GoalType.calories => LocaleKeys.goals_calories,
    GoalType.sleep => LocaleKeys.goals_sleep,
    GoalType.stress => LocaleKeys.goals_stress,
  };

  String get descriptionKey => switch (this) {
    GoalType.steps => LocaleKeys.goals_steps_desc,
    GoalType.water => LocaleKeys.goals_water_desc,
    GoalType.calories => LocaleKeys.goals_calories_desc,
    GoalType.sleep => LocaleKeys.goals_sleep_desc,
    GoalType.stress => LocaleKeys.goals_stress_desc,
  };
}

/// Status → Figma *Chips* variant + label.
extension GoalStatusUi on GoalStatus {
  StatusChipVariant get chipVariant => switch (this) {
    GoalStatus.complete => StatusChipVariant.success,
    GoalStatus.inProgress => StatusChipVariant.warning,
    GoalStatus.incomplete => StatusChipVariant.danger,
  };

  String get labelKey => switch (this) {
    GoalStatus.complete => LocaleKeys.goals_status_complete,
    GoalStatus.inProgress => LocaleKeys.goals_status_in_progress,
    GoalStatus.incomplete => LocaleKeys.goals_status_incomplete,
  };
}
