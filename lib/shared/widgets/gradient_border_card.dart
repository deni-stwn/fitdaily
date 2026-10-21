import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';

/// Home metric card (Figma *Card*): `bg`, radius 24, padding 20, 1px border
/// fading top → bottom. Figma uses the "Diagonal Border" style (not
/// exported); white 11% → 5% was measured from the screenshot.
class GradientBorderCard extends StatelessWidget {
  const GradientBorderCard({super.key, required this.child, this.padding = 20});

  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.xLarge.r);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x1CFFFFFF), Color(0x0DFFFFFF)],
        ),
      ),
      padding: const EdgeInsets.all(1),
      child: Container(
        padding: EdgeInsets.all((padding - 1).w),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(AppRadius.xLarge.r - 1),
        ),
        child: child,
      ),
    );
  }
}
