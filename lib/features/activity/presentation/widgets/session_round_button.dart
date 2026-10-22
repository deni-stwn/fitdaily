import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/brand_effects.dart';

/// Look of the 56×56 round icon *Button* in the training modals.
enum SessionRoundButtonVariant {
  /// `bgBrand` + Button Effect + glow (play / pause).
  brand,

  /// No fill (finish).
  plain,
}

/// Figma *Button* (icon only, 56×56, padding 16, icon 24) in the Start /
/// Active Session modals.
class SessionRoundButton extends StatelessWidget {
  const SessionRoundButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = SessionRoundButtonVariant.brand,
  });

  final String icon;
  final VoidCallback? onPressed;
  final SessionRoundButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final brand = variant == SessionRoundButtonVariant.brand;
    final size = 56.w;
    final radius = BorderRadius.circular(size / 2);
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: brand
                ? InnerShadowPainter(
                    color: AppColors.bgBrand,
                    border: null,
                    radius: radius,
                    shadows: buttonEffect,
                  )
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(icon, width: 24.w, height: 24.w),
                if (brand)
                  // figma: "Ellipse 6" 19.48×14 at (18.26, -7), white 70%;
                  // blur as AppButton (not in the export).
                  Positioned(
                    top: -7.w,
                    left: 18.26.w,
                    child: BlurredEllipse(
                      width: 19.48.w,
                      height: 14.w,
                      color: AppColors.textSecondary,
                      blur: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
