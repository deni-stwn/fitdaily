import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../manager/settings/settings_cubit.dart';
import '../widgets/settings_scaffold.dart';

/// Figma: Setting - Privacy & Data (683:53746): 3 toggles · Export Data
/// (Button Secondary) · Delete Account (Secondary, fill `bgDanger`).
/// No backend → both buttons only show a snackbar.
class PrivacyDataPage extends StatelessWidget {
  const PrivacyDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: LocaleKeys.settings_privacy_data.tr(context: context),
      builder: (context, settings) {
        final cubit = context.read<SettingsCubit>();
        final privacy = settings.privacy;
        return SettingsCard(
          children: [
            SettingsToggleRow(
              label: LocaleKeys.settings_media.tr(context: context),
              value: privacy.media,
              onChanged: (v) => cubit.update(
                (s) => s.copyWith(privacy: s.privacy.copyWith(media: v)),
              ),
            ),
            SettingsToggleRow(
              label: LocaleKeys.settings_data_share.tr(context: context),
              value: privacy.dataShare,
              onChanged: (v) => cubit.update(
                (s) => s.copyWith(privacy: s.privacy.copyWith(dataShare: v)),
              ),
            ),
            SettingsToggleRow(
              label: LocaleKeys.settings_contact.tr(context: context),
              value: privacy.contact,
              onChanged: (v) => cubit.update(
                (s) => s.copyWith(privacy: s.privacy.copyWith(contact: v)),
              ),
            ),
            Column(
              spacing: AppSpacing.s2.h,
              children: [
                AppButton(
                  label: LocaleKeys.settings_export_data.tr(context: context),
                  variant: AppButtonVariant.secondary,
                  fullWidth: true,
                  onPressed: () =>
                      _notify(context, LocaleKeys.settings_export_data_started),
                ),
                AppButton(
                  label: LocaleKeys.settings_delete_account.tr(
                    context: context,
                  ),
                  variant: AppButtonVariant.secondary,
                  backgroundColor: AppColors.bgDanger,
                  fullWidth: true,
                  onPressed: () => _notify(
                    context,
                    LocaleKeys.settings_delete_account_requested,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static void _notify(BuildContext context, String key) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(key.tr(context: context))));
  }
}
