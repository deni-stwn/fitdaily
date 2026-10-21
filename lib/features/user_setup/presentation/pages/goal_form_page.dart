import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_dropdown_field.dart';
import '../widgets/setup_fields.dart';
import '../../../../shared/widgets/setup_scaffold.dart';
import '../widgets/setup_illustrations.dart';

/// Figma: User Setup - Goal, form version (683:53983).
class GoalFormPage extends StatelessWidget {
  const GoalFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => key.tr(context: context);

    return SetupScaffold(
      illustration: setupTargetIllustration,
      title: t(LocaleKeys.user_setup_goals_title),
      subtitle: t(LocaleKeys.user_setup_goals_subtitle),
      primaryLabel: t(LocaleKeys.user_setup_save_goals),
      onPrimary: () => context.push(RouteNames.kUserSetupGoalsPage),
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
                label: t(LocaleKeys.user_setup_calories),
                hint: '0',
                unit: t(LocaleKeys.user_setup_unit_kcal),
              ),
            ),
            FieldRow(
              left: FieldBox80(
                child: NumberField(
                  label: t(LocaleKeys.user_setup_sleep),
                  hint: '0',
                  unit: t(LocaleKeys.user_setup_unit_hours),
                ),
              ),
              right: const FieldBox80(child: _TimeframeDropdown()),
            ),
          ],
        ),
      ],
    );
  }
}

enum _Timeframe {
  day(LocaleKeys.user_setup_timeframe_day),
  week(LocaleKeys.user_setup_timeframe_week),
  month(LocaleKeys.user_setup_timeframe_month);

  const _Timeframe(this.labelKey);

  final String labelKey;
}

class _TimeframeDropdown extends StatefulWidget {
  const _TimeframeDropdown();

  @override
  State<_TimeframeDropdown> createState() => _TimeframeDropdownState();
}

class _TimeframeDropdownState extends State<_TimeframeDropdown> {
  _Timeframe _value = _Timeframe.day;

  @override
  Widget build(BuildContext context) {
    return AppDropdownField<_Timeframe>(
      label: LocaleKeys.user_setup_timeframe.tr(context: context),
      value: _value,
      options: _Timeframe.values,
      optionLabel: (option) => option.labelKey.tr(context: context),
      onChanged: (value) => setState(() => _value = value),
    );
  }
}
