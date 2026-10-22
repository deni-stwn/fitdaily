import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';

/// Start Training button (figma: 3167…): `white200` circle (fills its
/// width, 72 in the frame) with a 24 coloured icon.
class TrainingTypeButton extends StatelessWidget {
  const TrainingTypeButton({super.key, required this.icon, this.onTap});

  /// Asset path.
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.white200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(icon, width: 24.w, height: 24.w),
          ),
        ),
      ),
    );
  }
}
