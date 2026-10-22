import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Variants of the Figma *Chips* component (`358:4997`).
enum StatusChipVariant {
  /// `bgSuccessTertiary` + `textSuccess` (Goals "Complete").
  success(AppColors.bgSuccessTertiary, AppColors.textSuccess),

  /// `bgWarningTertiary` + `textWarning` (Goals "In Progress").
  warning(AppColors.bgWarningTertiary, AppColors.textWarning),

  /// `bgDangerTertiary` + `textDanger` (Goals "Incomplete").
  danger(AppColors.bgDangerTertiary, AppColors.textDanger);

  const StatusChipVariant(this.background, this.foreground);

  final Color background;
  final Color foreground;
}

/// Figma *Chips* (`358:4997`, Success · Warning · Danger): pill (radius 100),
/// padding 8, label 12 Medium with line height 100% (→ 28 high). Width hugs
/// the label unless [width] is set (Goals list: fixed 80, label centred).
/// [textStyle] overrides the label style (Goals instances use text style
/// `bodySmallStrong` 12/16 → 32 high); colour always comes from [variant].
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.variant = StatusChipVariant.success,
    this.width,
    this.textStyle,
  });

  final String label;
  final StatusChipVariant variant;

  /// Fixed width in Figma px (null = hug).
  final double? width;

  /// Label style override (null = component default, line height 100%).
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      padding: EdgeInsets.all(AppSpacing.s2.w),
      alignment: width == null ? null : Alignment.center,
      decoration: BoxDecoration(
        color: variant.background,
        borderRadius: BorderRadius.circular(100.r), // figma: 100
      ),
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        style:
            textStyle?.copyWith(color: variant.foreground) ??
            // figma: line height 100%.
            AppTextStyles.bodySmallStrong.copyWith(
              color: variant.foreground,
              height: 1,
            ),
      ),
    );
  }
}
