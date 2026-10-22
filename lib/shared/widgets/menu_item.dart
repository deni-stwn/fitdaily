import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma component "Menu Item" (`658:38035`), seen in the Setting panel
/// (683:54836): row padding 16, radius 16 · icon 24 · gap 12 · label
/// `bodyMedium` `textSecondary`. Only the default look exists in the export.
class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  /// 24×24 SVG asset.
  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.s3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.large.r),
        ),
        child: Row(
          spacing: 12.w, // figma: 12
          children: [
            SvgPicture.asset(icon, width: 24.w, height: 24.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
