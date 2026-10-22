import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_text_styles.dart';
import 'app_icon_button.dart';

/// Figma component "Title Bar" (`360:8692`) — `Variant` property.
enum AppTitleBarVariant {
  /// *sub screen*: optional transparent back button (48 at x 20) + centred
  /// `heading/large` title, 8 below the button top (Password Reset).
  subScreen,

  /// *Default*: round `white200` back (48 at x 19.5) · centred
  /// `body/medium` title · round `white200` action (Overview screens).
  standard,
}

/// Figma "Title Bar". Menu/Notification variants: notification panel lives
/// in `features/home` (`NotificationPanel`); Menu is not built yet.
class AppTitleBar extends StatelessWidget {
  const AppTitleBar({
    super.key,
    required this.title,
    this.onBack,
    this.variant = AppTitleBarVariant.subScreen,
    this.actionIcon,
    this.onAction,
    this.titleStyle,
  });

  final String title;

  /// Shows the back button when not null.
  final VoidCallback? onBack;
  final AppTitleBarVariant variant;

  /// Trailing button (standard variant), e.g. `assets/icons/more.svg`.
  final String? actionIcon;
  final VoidCallback? onAction;

  /// Overrides the variant's title style (Setting sub pages: 16 Semi Bold →
  /// `bodyLargeStrong`).
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      AppTitleBarVariant.subScreen => _subScreen(),
      AppTitleBarVariant.standard => _standard(),
    };
  }

  Widget _subScreen() {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 8.h, // figma: title top 92 − button top 84
            left: 0,
            right: 0,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle ?? AppTextStyles.headingLarge,
            ),
          ),
          if (onBack != null)
            Positioned(
              left: 20.w,
              top: 0,
              child: GestureDetector(
                onTap: onBack,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 48.w,
                  height: 48.w,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/arrow_left.svg',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _standard() {
    return Padding(
      // figma: 401 wide at x 19.5
      padding: EdgeInsets.symmetric(horizontal: 19.5.w),
      child: SizedBox(
        height: 48.h,
        child: Row(
          children: [
            if (onBack != null)
              AppIconButton(
                icon: 'assets/icons/arrow_left.svg',
                onPressed: onBack!,
              )
            else
              SizedBox(width: 48.w),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: titleStyle ?? AppTextStyles.bodyMedium,
              ),
            ),
            if (actionIcon != null)
              AppIconButton(icon: actionIcon!, onPressed: onAction ?? () {})
            else
              SizedBox(width: 48.w),
          ],
        ),
      ),
    );
  }
}
