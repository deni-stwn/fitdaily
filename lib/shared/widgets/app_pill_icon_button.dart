import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';

/// Icon-only Figma *Button* (Secondary, medium): `white200` pill 36×44,
/// padding 12/8, 20 icon — "Add new devices" search (683:53253) and the
/// *Accordion* toggle (652:32627).
class AppPillIconButton extends StatelessWidget {
  const AppPillIconButton({super.key, required this.icon, this.onPressed});

  /// SVG asset (20×20).
  final String icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s2.w,
          vertical: 12.h, // figma: 12
        ),
        decoration: BoxDecoration(
          color: AppColors.white200,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: SvgPicture.asset(icon, width: 20.w, height: 20.w),
      ),
    );
  }
}
