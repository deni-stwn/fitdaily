import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../manager/setup_goal.dart';
import '../widgets/goal_detail_scaffold.dart';
import '../widgets/reminder_row.dart';
import '../widgets/setup_fields.dart';

/// Figma: User Setup - Daily Routine "Stay Active Daily" (683:54012).
class StayActivePage extends StatelessWidget {
  const StayActivePage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => key.tr(context: context);
    return GoalDetailScaffold(
      goal: SetupGoal.stayActive,
      title: t(LocaleKeys.user_setup_stay_active_title),
      subtitle: t(LocaleKeys.user_setup_stay_active_subtitle),
      children: [
        FieldRow(
          left: NumberField(
            label: t(LocaleKeys.user_setup_daily_steps),
            hint: '400',
            unit: t(LocaleKeys.user_setup_unit_step),
          ),
          right: NumberField(
            label: t(LocaleKeys.user_setup_daily_active),
            hint: '45',
            unit: t(LocaleKeys.user_setup_unit_minutes),
          ),
        ),
      ],
    );
  }
}

/// Figma: User Setup - Ideal Weight (683:54036).
class IdealWeightPage extends StatelessWidget {
  const IdealWeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => key.tr(context: context);
    return GoalDetailScaffold(
      goal: SetupGoal.loseWeight,
      title: t(LocaleKeys.user_setup_ideal_weight_title),
      subtitle: t(LocaleKeys.user_setup_ideal_weight_subtitle),
      children: [
        Column(
          spacing: AppSpacing.s2.h,
          children: [
            FieldRow(
              left: NumberField(
                label: t(LocaleKeys.user_setup_current_weight),
                hint: '0.0',
                unit: t(LocaleKeys.user_setup_unit_kg),
                decimal: true,
              ),
              right: NumberField(
                label: t(LocaleKeys.user_setup_weight_goal),
                hint: '0.0',
                unit: t(LocaleKeys.user_setup_unit_kg),
                decimal: true,
              ),
            ),
            FieldBox80(
              child: NumberField(
                label: t(LocaleKeys.user_setup_target_duration),
                hint: '0',
                unit: t(LocaleKeys.user_setup_unit_weeks),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Figma: User Setup - Sleep Goal (683:54062).
class SleepGoalPage extends StatelessWidget {
  const SleepGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => key.tr(context: context);
    return GoalDetailScaffold(
      goal: SetupGoal.betterSleep,
      title: t(LocaleKeys.user_setup_sleep_title),
      subtitle: t(LocaleKeys.user_setup_sleep_subtitle),
      children: [
        Column(
          spacing: AppSpacing.s2.h,
          children: [
            FieldBox80(
              child: NumberField(
                label: t(LocaleKeys.user_setup_sleep_duration),
                hint: '0',
                unit: t(LocaleKeys.user_setup_unit_hours),
              ),
            ),
            FieldRow(
              left: TimeField(label: t(LocaleKeys.user_setup_sleep_time)),
              right: TimeField(label: t(LocaleKeys.user_setup_wake_up_time)),
            ),
          ],
        ),
      ],
    );
  }
}

/// Relax duration (80) · Relax time · Reminder — shared by 14 and 15.
class _RelaxFields extends StatelessWidget {
  const _RelaxFields();

  @override
  Widget build(BuildContext context) {
    String t(String key) => key.tr(context: context);
    return Column(
      spacing: AppSpacing.s2.h,
      children: [
        FieldBox80(
          child: NumberField(
            label: t(LocaleKeys.user_setup_relax_duration),
            hint: '0',
            unit: t(LocaleKeys.user_setup_unit_hours),
          ),
        ),
        TimeField(label: t(LocaleKeys.user_setup_relax_time)),
        const ReminderRow(),
      ],
    );
  }
}

/// Figma: User Setup - Stress Management (683:54088).
class StressPage extends StatelessWidget {
  const StressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GoalDetailScaffold(
      goal: SetupGoal.reduceStress,
      title: LocaleKeys.user_setup_stress_title.tr(context: context),
      subtitle: LocaleKeys.user_setup_stress_subtitle.tr(context: context),
      children: const [_RelaxFields()],
    );
  }
}

/// Figma: User Setup - Commitment "Be More Consistent" (683:54115).
class ConsistentPage extends StatelessWidget {
  const ConsistentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GoalDetailScaffold(
      goal: SetupGoal.beConsistent,
      title: LocaleKeys.user_setup_consistent_title.tr(context: context),
      subtitle: LocaleKeys.user_setup_consistent_subtitle.tr(context: context),
      children: const [_RelaxFields()],
    );
  }
}
