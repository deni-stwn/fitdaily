import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/greeting_header.dart';
import '../../../../shared/widgets/menu_item.dart';
import '../manager/settings/settings_cubit.dart';
import '../manager/settings/settings_state.dart';

/// Figma: Setting (683:54836) — panel dropping from the top over the current
/// tab page, behind it the *Blurred Effect · full* (`#262626` 20% + background
/// blur; blur radius not in the export → tuned). Route
/// [RouteNames.kSettingsPage] (transparent page, opened by tapping the
/// avatar of `GreetingHeader`).
class SettingsPanelPage extends StatelessWidget {
  const SettingsPanelPage({super.key});

  /// Fade + slight drop from the top.
  static Widget transition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, -0.04),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>()..loadData(),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: context.pop,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: const ColoredBox(color: AppColors.blurOverlay),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              // figma: panel at (8, 80) → 20 below the 60px status bar.
              padding: EdgeInsets.fromLTRB(8.w, 20.h, 8.w, 0),
              child: const Align(
                alignment: Alignment.topCenter,
                child: SettingsPanel(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Panel content: 424 wide, `bg`, radius 32, padding 12, gap 24 · header ·
/// menu card (`bgSecondary`, radius 24, padding 8) with 5 *Menu Item*s.
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  static const _items = [
    (
      'assets/icons/settings_personal_info.svg',
      LocaleKeys.settings_personal_info,
      RouteNames.kSettingsPersonalInfoPage,
    ),
    (
      'assets/icons/settings_health.svg',
      LocaleKeys.settings_health_settings,
      RouteNames.kSettingsHealthPage,
    ),
    (
      'assets/icons/bell.svg',
      LocaleKeys.settings_notifications,
      RouteNames.kSettingsNotificationsPage,
    ),
    (
      'assets/icons/settings_privacy.svg',
      LocaleKeys.settings_privacy_data,
      RouteNames.kSettingsPrivacyPage,
    ),
    (
      'assets/icons/settings_app.svg',
      LocaleKeys.settings_app_settings,
      RouteNames.kSettingsAppPage,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoaded) return const SizedBox.shrink();
        final profile = state.settings.profile;
        return Material(
          type: MaterialType.transparency,
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.s4.h,
              children: [
                GreetingHeader(
                  name: profile.name,
                  avatar: profile.avatar,
                  opensSettings: false,
                  trailing: AppIconButton(
                    icon: 'assets/icons/close.svg',
                    filled: false,
                    onPressed: context.pop,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(AppSpacing.s2.w),
                  decoration: BoxDecoration(
                    color: AppColors.bgSecondary,
                    borderRadius: BorderRadius.circular(AppRadius.xLarge.r),
                  ),
                  child: Column(
                    children: [
                      for (final (icon, label, route) in _items)
                        MenuItem(
                          icon: icon,
                          label: label.tr(context: context),
                          onTap: () => context.push(route),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
