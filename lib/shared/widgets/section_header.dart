import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma component "Header" (`619:6259`): title (`bodyMedium`) and, on the
/// right, either a text button with chevron (*Type=Button*, e.g. "View all")
/// or a 32×32 chevron (*Type=Icon Trailing*, only when [onAction] is set —
/// Overview "Summary" has an empty 32 slot). Optional leading [icon] (24,
/// gap 8 — Activity cards). *Type=Detail* not built yet.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.actionChevron = true,
    this.actionColor = AppColors.text,
    this.trailing,
  });

  final String title;

  /// Leading 24 icon (asset path), gap 8.
  final String? icon;

  /// Null → icon-only trailing chevron (or nothing without [onAction]).
  final String? actionLabel;
  final VoidCallback? onAction;

  /// *Type=Button*: chevron after [actionLabel]. Home "See Full Activity"
  /// hides both button icons (label only, padding 16 each side).
  final bool actionChevron;

  /// *Type=Button* label colour (Home "See Full Activity" = `textSecondary`).
  final Color actionColor;

  /// Custom right slot (Goals "+" 40×40 button); replaces the action /
  /// chevron slot. `SizedBox.shrink()` = title-only header (18 high).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final chevron = SvgPicture.asset(
      'assets/icons/chevron_right.svg',
      width: 16.w,
      height: 16.w,
    );
    return Row(
      children: [
        if (icon != null) ...[
          SvgPicture.asset(icon!, width: 24.w, height: 24.w),
          SizedBox(width: AppSpacing.s2.w),
        ],
        Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
        if (trailing != null)
          trailing!
        else
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              height: 32.h,
              child: actionLabel == null
                  ? SizedBox(
                      width: 32.w,
                      child: onAction == null ? null : Center(child: chevron),
                    )
                  : Padding(
                      // figma: padding 8 + label padding 8
                      padding: EdgeInsets.only(
                        left: AppSpacing.s3.w,
                        right: actionChevron
                            ? AppSpacing.s2.w
                            : AppSpacing.s3.w,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            actionLabel!,
                            style: AppTextStyles.bodySmallStrong.copyWith(
                              color: actionColor,
                            ),
                          ),
                          if (actionChevron) ...[
                            SizedBox(width: AppSpacing.s2.w),
                            chevron,
                          ],
                        ],
                      ),
                    ),
            ),
          ),
      ],
    );
  }
}
