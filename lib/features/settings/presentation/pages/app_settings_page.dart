import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_dropdown_field.dart';
import '../manager/settings/settings_cubit.dart';
import '../manager/settings/settings_state.dart';
import '../widgets/settings_scaffold.dart';

/// Figma: Setting - App Settings (683:53770): Language dropdown. Save also
/// switches the app locale.
class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  static String _languageKey(String code) => switch (code) {
    'ar' => LocaleKeys.settings_language_ar,
    _ => LocaleKeys.settings_language_en,
  };

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: LocaleKeys.settings_app_settings.tr(context: context),
      onSave: (context) {
        final state = context.read<SettingsCubit>().state;
        if (state is SettingsLoaded) {
          context.setLocale(Locale(state.settings.language));
        }
      },
      builder: (context, settings) {
        final cubit = context.read<SettingsCubit>();
        return SettingsCard(
          children: [
            AppDropdownField<String>(
              label: LocaleKeys.settings_language.tr(context: context),
              value: settings.language,
              options: settings.options.languages,
              optionLabel: (code) => _languageKey(code).tr(context: context),
              onChanged: (v) => cubit.update((s) => s.copyWith(language: v)),
            ),
          ],
        );
      },
    );
  }
}
