import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';

/// Round 48×48 icon button (Home bell `white200`, panel close transparent),
/// 24×24 icon centred.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.filled = true,
    this.size = 48,
    this.iconSize = 24,
  });

  final String icon;
  final VoidCallback onPressed;

  /// `white200` background when true, transparent otherwise.
  final bool filled;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size.w,
        height: size.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.white200 : null,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon, width: iconSize.w, height: iconSize.w),
      ),
    );
  }
}
