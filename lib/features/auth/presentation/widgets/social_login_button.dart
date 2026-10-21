import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';

enum SocialProvider {
  apple('assets/icons/social_apple.svg'),
  facebook('assets/icons/social_facebook.svg'),
  google('assets/icons/social_google.svg');

  const SocialProvider(this.icon);

  final String icon;
}

/// Circular social sign-in button (figma: 683:53855) — 48×48,
/// `bgTertiary`, 24×24 icon centred.
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  final SocialProvider provider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48.w,
        height: 48.w,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.bgTertiary,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(provider.icon, width: 24.w, height: 24.w),
      ),
    );
  }
}
