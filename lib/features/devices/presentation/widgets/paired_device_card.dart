import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../domain/entities/devices_overview.dart';
import 'device_connection_x.dart';

/// Device card of the top row (figma: Devices 683:53253, *Card* 138.67
/// wide): name / status (`bodyMedium`, gap 4) · gap 16 · square photo ·
/// gap 16 · "Synced" + "last sync 12:09" (10/100%, gap 4) · gap 16 · 24
/// "…" icon.
class PairedDeviceCard extends StatelessWidget {
  const PairedDeviceCard({super.key, required this.device, this.onTap});

  final UserDevice device;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // figma: 10 / line-height 100% — no text style token.
    final sync = AppTextStyles.bodySmallStrong.copyWith(
      fontSize: 10.sp,
      height: 1,
    );
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: GradientBorderCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s3.h,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s1.h,
              children: [
                Text(
                  device.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  device.connection.labelKey.tr(context: context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(device.image, fit: BoxFit.cover),
            ),
            Row(
              spacing: AppSpacing.s3.w,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.s1.h,
                    children: [
                      if (device.synced)
                        Text(
                          LocaleKeys.devices_synced.tr(context: context),
                          style: sync,
                        ),
                      Text(
                        LocaleKeys.devices_last_sync.tr(
                          context: context,
                          args: [device.lastSync],
                        ),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10.sp,
                          height: 1,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/more_tertiary.svg',
                  width: 24.w,
                  height: 24.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
