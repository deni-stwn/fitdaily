import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/device_entity.dart';

/// Device row (figma: 683:53955): padding 16, photo 48 · name/status (gap 4)
/// · status icon 24.
class DeviceTile extends StatelessWidget {
  const DeviceTile({super.key, required this.device, required this.onTap});

  final DeviceEntity device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.s3.w),
        child: Row(
          spacing: AppSpacing.s2.w,
          children: [
            Image.asset(device.image, width: 48.w, height: 48.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s1.h,
                children: [
                  Text(device.name, style: AppTextStyles.bodyMedium),
                  Text(
                    (device.connected
                            ? LocaleKeys.device_setup_connected
                            : LocaleKeys.device_setup_not_connected)
                        .tr(context: context),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              device.connected
                  ? 'assets/icons/tick_circle.svg'
                  : 'assets/icons/link.svg',
              width: 24.w,
              height: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}
