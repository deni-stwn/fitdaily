import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_password_field.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/user_settings.dart';
import '../manager/settings/settings_cubit.dart';
import '../widgets/settings_scaffold.dart';

/// Figma: Setting - Personal Info (683:53705). Fields show the stored value
/// as placeholder (Figma: `textTertiary`); typed text replaces it on Save.
class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _fullName = TextEditingController();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    for (final c in [_fullName, _weight, _height, _username, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  static String? _typed(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  void _applyTyped(BuildContext context) {
    context.read<SettingsCubit>().update(
      (s) => s.copyWith(
        profile: s.profile.copyWith(
          fullName: _typed(_fullName),
          weight: _typed(_weight),
          height: _typed(_height),
          username: _typed(_username),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: LocaleKeys.settings_personal_info.tr(context: context),
      bottomFade: true,
      onSave: _applyTyped,
      builder: (context, settings) {
        final profile = settings.profile;
        return Column(
          spacing: AppSpacing.s2.h,
          children: [
            SettingsCard(
              children: [
                Column(
                  spacing: AppSpacing.s3.h,
                  children: [
                    AppAvatar(image: profile.avatar, size: AppAvatarSize.md),
                    // No image picker in the project yet → no action.
                    AppButton(
                      label: LocaleKeys.settings_change_picture.tr(
                        context: context,
                      ),
                      trailingIcon: SvgPicture.asset(
                        'assets/icons/edit_pen.svg',
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                AppTextField(
                  label: LocaleKeys.settings_full_name.tr(context: context),
                  hint: profile.fullName,
                  controller: _fullName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
                AppTextField(
                  label: LocaleKeys.settings_date_of_birth.tr(context: context),
                  hint: profile.birthDate,
                  readOnly: true,
                  onTap: () => _pickBirthDate(context, profile),
                  suffix: SvgPicture.asset(
                    'assets/icons/calendar.svg',
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
                Row(
                  spacing: AppSpacing.s2.w,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: LocaleKeys.settings_weight.tr(context: context),
                        hint: profile.weight,
                        controller: _weight,
                        suffixText: LocaleKeys.settings_kg.tr(context: context),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppTextField(
                        label: LocaleKeys.settings_height.tr(context: context),
                        hint: profile.height,
                        controller: _height,
                        suffixText: LocaleKeys.settings_cm.tr(context: context),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SettingsCard(
              children: [
                AppTextField(
                  label: LocaleKeys.settings_username.tr(context: context),
                  hint: profile.username,
                  controller: _username,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                AppPasswordField(
                  label: LocaleKeys.settings_password.tr(context: context),
                  hint: LocaleKeys.settings_password_hint.tr(context: context),
                  controller: _password,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickBirthDate(BuildContext context, UserProfile profile) async {
    final cubit = context.read<SettingsCubit>();
    final picked = await showDatePicker(
      context: context,
      initialDate: _parseBirthDate(profile.birthDate) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    cubit.update(
      (s) => s.copyWith(
        profile: s.profile.copyWith(birthDate: formatBirthDate(picked)),
      ),
    );
  }

  static DateTime? _parseBirthDate(String value) {
    final cleaned = value.replaceFirstMapped(
      RegExp(r'^(\d+)(st|nd|rd|th)'),
      (m) => m[1]!,
    );
    return DateFormat('d MMMM yyyy', 'en').tryParse(cleaned);
  }
}

/// "20th January 2022" (Figma format).
String formatBirthDate(DateTime date) {
  final day = date.day;
  final suffix = (day >= 11 && day <= 13)
      ? 'th'
      : switch (day % 10) {
          1 => 'st',
          2 => 'nd',
          3 => 'rd',
          _ => 'th',
        };
  return '$day$suffix ${DateFormat('MMMM yyyy', 'en').format(date)}';
}
