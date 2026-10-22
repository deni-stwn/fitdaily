import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';

/// Base of the Figma *Modal* component (`691:13113`…): `bg`, radius 24,
/// 1px inside border white 20% → 5% (top-left → bottom-right), padding
/// 20 (Finish Session 16).
class TrainingModal extends StatelessWidget {
  const TrainingModal({
    super.key,
    required this.child,
    this.padding = 20,
    this.height,
  });

  final Widget child;
  final double padding;

  /// Fixed height (Input Target 201); hug when null.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final radius = AppRadius.xLarge.r;
    return Container(
      height: height?.h,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.white.withValues(alpha: 0.2), AppColors.white100],
        ),
      ),
      child: Container(
        padding: EdgeInsets.all((padding - 1).w),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(radius - 1),
        ),
        child: child,
      ),
    );
  }
}
