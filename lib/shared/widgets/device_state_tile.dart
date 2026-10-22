import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma component "Device State" (`644:25566`) — variant = trailing icon.
enum DeviceStateVariant {
  /// Paired / connected: `tick_circle.svg`.
  pairing,

  /// 270° ring (Ellipse arc, stroke 2.5): `device_connecting.svg`.
  connecting,

  /// Not connected: `link.svg`.
  disconnect,
}

extension on DeviceStateVariant {
  String get icon => switch (this) {
    DeviceStateVariant.pairing => 'assets/icons/tick_circle.svg',
    DeviceStateVariant.connecting => 'assets/icons/device_connecting.svg',
    DeviceStateVariant.disconnect => 'assets/icons/link.svg',
  };
}

/// Figma "Device State": `bgSecondary` box, radius 16, padding 16, photo 48
/// · gap 8 · name (`bodyMedium`) / gap 4 / status (`bodySmall`
/// `textMuted`) · 24 state icon (Devices 683:53253).
class DeviceStateTile extends StatelessWidget {
  const DeviceStateTile({
    super.key,
    required this.image,
    required this.name,
    required this.status,
    required this.variant,
    this.onTap,
  });

  /// Device photo asset path.
  final String image;
  final String name;

  /// Status text ("Connected", "Connecting", "Not Connected").
  final String status;
  final DeviceStateVariant variant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.s3.w),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(AppRadius.large.r),
        ),
        child: Row(
          spacing: AppSpacing.s2.w,
          children: [
            Image.asset(image, width: 48.w, height: 48.w, fit: BoxFit.cover),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s1.h,
                children: [
                  Text(name, style: AppTextStyles.bodyMedium),
                  Text(
                    status,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(variant.icon, width: 24.w, height: 24.w),
          ],
        ),
      ),
    );
  }
}
