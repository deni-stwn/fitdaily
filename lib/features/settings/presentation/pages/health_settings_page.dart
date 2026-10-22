import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_dropdown_field.dart';
import '../manager/settings/settings_cubit.dart';
import '../widgets/settings_scaffold.dart';

/// Figma: Setting - Heath Settings (683:53732): Units · Target Heart Rate
/// zone dropdowns.
class HealthSettingsPage extends StatelessWidget {
  const HealthSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: LocaleKeys.settings_health_settings.tr(context: context),
      builder: (context, settings) {
        final cubit = context.read<SettingsCubit>();
        final health = settings.health;
        return SettingsCard(
          children: [
            AppDropdownField<String>(
              label: LocaleKeys.settings_units.tr(context: context),
              value: health.units,
              options: settings.options.units,
              optionLabel: (o) => o,
              onChanged: (v) => cubit.update(
                (s) => s.copyWith(health: s.health.copyWith(units: v)),
              ),
            ),
            AppDropdownField<String>(
              label: LocaleKeys.settings_target_heart_rate_zone.tr(
                context: context,
              ),
              value: health.heartRateZone,
              options: settings.options.heartRateZones,
              optionLabel: (o) => o,
              onChanged: (v) => cubit.update(
                (s) => s.copyWith(health: s.health.copyWith(heartRateZone: v)),
              ),
            ),
          ],
        );
      },
    );
  }
}
