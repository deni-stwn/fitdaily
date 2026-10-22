import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/app_toggle.dart';
import '../../../../shared/widgets/bottom_fade.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/user_settings.dart';
import '../manager/settings/settings_cubit.dart';
import '../manager/settings/settings_state.dart';

/// Layout shared by the Setting sub pages (683:53705 / 53732 / 53746 /
/// 53770 / 54653): background + light effect · Title Bar (back 48 at y 78,
/// title 16 Semi Bold) · cards from y 148 (x 8, 424 wide, gap 8) ·
/// "Save" 400×48 fixed at the bottom (y 866 → 42 above the frame bottom).
class SettingsScaffold extends StatelessWidget {
  const SettingsScaffold({
    super.key,
    required this.title,
    required this.builder,
    this.onSave,
    this.bottomFade = false,
  });

  final String title;

  /// Card content for the loaded settings (draft).
  final Widget Function(BuildContext context, UserSettings settings) builder;

  /// Runs before the draft is stored (e.g. copy text fields into it).
  final void Function(BuildContext context)? onSave;

  /// Personal Info: *Blurred Effect* above the Save button (y 772 → bottom).
  final bool bottomFade;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>()..loadData(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: AppBackground(
            child: Stack(
              children: [
                // figma: "light effect" #1F076E 582×376 at (-71, -190).
                Positioned(
                  left: -71.w,
                  top: -190.h,
                  child: BlurredEllipse(
                    width: 582.w,
                    height: 376.h,
                    color: AppColors.violet1000,
                    blur: 200,
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      SizedBox(height: 18.h), // figma: back button y 78
                      AppTitleBar(
                        variant: AppTitleBarVariant.standard,
                        title: title,
                        onBack: context.pop,
                        titleStyle: AppTextStyles.bodyLargeStrong,
                      ),
                      SizedBox(height: 22.h), // figma: cards y 148
                      Expanded(
                        child: BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (context, state) {
                            if (state is! SettingsLoaded) {
                              return const LoadingWidget();
                            }
                            return SingleChildScrollView(
                              // Room to scroll the last card above "Save".
                              padding: EdgeInsets.fromLTRB(
                                AppSpacing.s2.w,
                                0,
                                AppSpacing.s2.w,
                                120.h,
                              ),
                              child: builder(context, state.settings),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (bottomFade)
                  // figma: 192 high at y 772 (8 past the frame) → 184 visible.
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BottomFade(height: 184),
                  ),
                Positioned(
                  left: 20.w,
                  right: 20.w,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    minimum: EdgeInsets.only(bottom: 20.h),
                    child: Padding(
                      // figma: 42 above the frame bottom = 34 home bar + 8.
                      padding: EdgeInsets.only(bottom: AppSpacing.s2.h),
                      child: Builder(
                        builder: (context) => AppButton(
                          label: LocaleKeys.settings_save.tr(context: context),
                          fullWidth: true,
                          onPressed: () => _save(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// No backend: store the draft in memory and go back to the panel.
  Future<void> _save(BuildContext context) async {
    onSave?.call(context);
    final saved = await context.read<SettingsCubit>().save();
    if (saved && context.mounted) context.pop();
  }
}

/// Label (`bodySmall` `textSecondary`) ··· *Toggle* (row 24, gap 16).
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.s3.w,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        AppToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}

/// Form card of the sub pages: *Card* (`bg`, radius 24, padding 20) with
/// fields 16 apart.
class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3.h,
        children: children,
      ),
    );
  }
}
