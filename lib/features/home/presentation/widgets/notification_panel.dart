import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../domain/entities/home_dashboard.dart';
import '../manager/home/home_cubit.dart';
import '../manager/home/home_state.dart';
import 'home_header.dart';

/// Opens the Figma *Title Bar · Notification* panel (683:54696) over a
/// blurred Home. Blur/dim values are not in the export → approximated.
Future<void> showNotificationPanel(BuildContext context) {
  final cubit = context.read<HomeCubit>();
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'notifications',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) =>
        BlocProvider.value(value: cubit, child: const _NotificationOverlay()),
    transitionBuilder: (_, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

class _NotificationOverlay extends StatelessWidget {
  const _NotificationOverlay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: BackdropFilter(
              // Tuned against the screenshot (Home stays fairly visible).
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: const ColoredBox(color: Color(0x1A000000)),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            // figma: panel at (8, 73) → 13 below the 60px status bar.
            padding: EdgeInsets.fromLTRB(8.w, 13.h, 8.w, 0),
            child: const Align(
              alignment: Alignment.topCenter,
              child: NotificationPanel(),
            ),
          ),
        ),
      ],
    );
  }
}

/// Panel content: 424 × 697, `bg`, radius 32, padding 12.
class NotificationPanel extends StatelessWidget {
  const NotificationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoaded) return const SizedBox.shrink();
        final dashboard = state.dashboard;
        return Material(
          type: MaterialType.transparency,
          child: Container(
            height: 697.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                HomeHeader(
                  name: dashboard.userName,
                  avatar: dashboard.avatar,
                  trailing: AppIconButton(
                    icon: 'assets/icons/close.svg',
                    filled: false,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(height: AppSpacing.s4.h),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: dashboard.notifications.length,
                    separatorBuilder: (_, _) => SizedBox(height: 4.h),
                    itemBuilder: (_, i) =>
                        _NotificationItem(dashboard.notifications[i]),
                  ),
                ),
                AppButton(
                  label: LocaleKeys.home_clear_notifications.tr(
                    context: context,
                  ),
                  fullWidth: true,
                  onPressed: () {
                    context.read<HomeCubit>().clearNotifications();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem(this.notification);

  final HomeNotification notification;

  /// Icon + optional tint (sleep/stress reuse the goal icons recoloured;
  /// the white flame is still to be exported → yellow flame tinted white).
  static (String, Color?) _icon(HomeNotificationType type) => switch (type) {
    HomeNotificationType.calories => (
      'assets/icons/metric_calories.svg',
      AppColors.icon,
    ),
    HomeNotificationType.steps => ('assets/icons/metric_steps.svg', null),
    HomeNotificationType.movingTime => ('assets/icons/notif_timer.svg', null),
    HomeNotificationType.sleep => (
      'assets/icons/goal_better_sleep.svg',
      AppColors.iconBrandSecondary,
    ),
    HomeNotificationType.stress => (
      'assets/icons/goal_reduce_stress.svg',
      AppColors.iconDanger,
    ),
  };

  Widget _message({bool softWrap = true}) => Text(
    notification.message,
    softWrap: softWrap,
    overflow: TextOverflow.visible,
    style: AppTextStyles.bodySmallStrong.copyWith(
      color: AppColors.textTertiary,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final (asset, tint) = _icon(notification.type);
    return Container(
      constraints: BoxConstraints(minHeight: (notification.minHeight ?? 0).h),
      padding: EdgeInsets.all(AppSpacing.s3.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(AppRadius.large.r),
      ),
      child: Row(
        spacing: 10.w,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              asset,
              width: 24.w,
              height: 24.w,
              colorFilter: tint == null
                  ? null
                  : ColorFilter.mode(tint, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2.h,
              children: [
                Text(notification.title, style: AppTextStyles.bodyMedium),
                // Figma: fixed-width message layers wrap, the others hug
                // (one line, may run slightly past the padding).
                if (notification.messageWidth case final width?)
                  SizedBox(width: width.w, child: _message())
                else
                  _message(softWrap: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
