import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/blurred_overlay.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../domain/entities/devices_overview.dart';
import '../manager/devices_overview/devices_overview_cubit.dart';
import 'device_connection_x.dart';

/// Devices - Detail (703:12420): Blurred Effect (20%) over the Devices tab
/// + bottom card (x 8, 424 wide, 8 above the home indicator).
Future<void> showDeviceDetailSheet(BuildContext context, UserDevice device) {
  final cubit = context.read<DevicesOverviewCubit>();
  return showGeneralDialog(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierLabel: 'device detail',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, _, _) => BlocProvider.value(
      value: cubit,
      child: _DetailOverlay(device: device),
    ),
    transitionBuilder: (_, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

class _DetailOverlay extends StatelessWidget {
  const _DetailOverlay({required this.device});

  final UserDevice device;

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    final slide = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: route?.animation ?? kAlwaysCompleteAnimation,
        curve: Curves.easeOutCubic,
      ),
    );
    return Stack(
      children: [
        Positioned.fill(
          child: BlurredOverlay(
            opacity: 0.2, // figma: #262626 20%
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s2.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2.w),
              child: SlideTransition(
                position: slide,
                child: Material(
                  type: MaterialType.transparency,
                  child: _DetailCard(device: device),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.device});

  final UserDevice device;

  @override
  Widget build(BuildContext context) {
    String t(String key) => key.tr(context: context);
    final rows = [
      (t(LocaleKeys.devices_device_id), device.deviceId),
      (t(LocaleKeys.devices_device_name), device.deviceName),
      (t(LocaleKeys.devices_battery), '${device.battery}%'),
      (
        t(LocaleKeys.devices_synced),
        LocaleKeys.devices_last_sync.tr(
          context: context,
          args: [device.lastSync],
        ),
      ),
    ];

    void close() => Navigator.of(context).pop();

    return GradientBorderCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3.h,
        children: [
          Column(
            spacing: AppSpacing.s1.h,
            children: [
              Text(
                device.name,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              Text(
                t(device.connection.labelKey),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          Center(
            child: Image.asset(
              device.image,
              width: 232.w,
              height: 232.w,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s3.h,
            children: [
              Column(
                spacing: AppSpacing.s1.h,
                children: [
                  for (final (label, value) in rows)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s2.h),
                      child: Row(
                        spacing: AppSpacing.s3.w,
                        children: [
                          Text(label, style: AppTextStyles.bodySmallStrong),
                          Expanded(
                            child: Text(
                              value,
                              textAlign: TextAlign.end,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Column(
                spacing: AppSpacing.s2.h,
                children: [
                  AppButton(
                    label: t(LocaleKeys.devices_unbind),
                    variant: AppButtonVariant.secondary,
                    size: AppButtonSize.medium,
                    fullWidth: true,
                    onPressed: () {
                      context.read<DevicesOverviewCubit>().unbind(device.id);
                      close();
                    },
                  ),
                  AppButton(
                    label: t(LocaleKeys.devices_forget_device),
                    variant: AppButtonVariant.secondary,
                    size: AppButtonSize.medium,
                    backgroundColor: AppColors.bgDanger,
                    fullWidth: true,
                    onPressed: () {
                      context.read<DevicesOverviewCubit>().forget(device.id);
                      close();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
