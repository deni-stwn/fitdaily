import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_dropdown_field.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../manager/settings/settings_cubit.dart';
import '../widgets/settings_scaffold.dart';

/// Figma: Setting - Notifications Settings (683:54653): Reminders toggle +
/// Time · Units (gap 8 under it) · Inactivity alerts · Sleep Reminders.
class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  final _time = TextEditingController();

  @override
  void dispose() {
    _time.dispose();
    super.dispose();
  }

  void _applyTyped(BuildContext context) {
    final typed = _time.text.trim();
    if (typed.isEmpty) return;
    context.read<SettingsCubit>().update(
      (s) => s.copyWith(
        notifications: s.notifications.copyWith(reminderTime: typed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: LocaleKeys.settings_notifications_settings.tr(context: context),
      onSave: _applyTyped,
      builder: (context, settings) {
        final cubit = context.read<SettingsCubit>();
        final notif = settings.notifications;
        return SettingsCard(
          children: [
            Column(
              spacing: AppSpacing.s2.h,
              children: [
                SettingsToggleRow(
                  label: LocaleKeys.settings_reminders.tr(context: context),
                  value: notif.reminders,
                  onChanged: (v) => cubit.update(
                    (s) => s.copyWith(
                      notifications: s.notifications.copyWith(reminders: v),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s2.w,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: LocaleKeys.settings_time.tr(context: context),
                        hint: notif.reminderTime,
                        controller: _time,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: AppDropdownField<String>(
                        label: LocaleKeys.settings_units.tr(context: context),
                        value: notif.reminderUnit,
                        options: settings.options.reminderUnits,
                        optionLabel: (o) => o,
                        onChanged: (v) => cubit.update(
                          (s) => s.copyWith(
                            notifications: s.notifications.copyWith(
                              reminderUnit: v,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SettingsToggleRow(
              label: LocaleKeys.settings_inactivity_alerts.tr(context: context),
              value: notif.inactivityAlerts,
              onChanged: (v) => cubit.update(
                (s) => s.copyWith(
                  notifications: s.notifications.copyWith(inactivityAlerts: v),
                ),
              ),
            ),
            SettingsToggleRow(
              label: LocaleKeys.settings_sleep_reminders.tr(context: context),
              value: notif.sleepReminders,
              onChanged: (v) => cubit.update(
                (s) => s.copyWith(
                  notifications: s.notifications.copyWith(sleepReminders: v),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
