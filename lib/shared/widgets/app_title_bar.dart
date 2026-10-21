import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_text_styles.dart';

/// Figma component "Title Bar" (`360:8692`), variant *sub screen*:
/// optional back button (48×48 at x 20) + centred `heading/large` title
/// (8 below the button top). Other variants (Default/Menu/Notification)
/// are added when a screen uses them.
class AppTitleBar extends StatelessWidget {
  const AppTitleBar({super.key, required this.title, this.onBack});

  final String title;

  /// Shows the back button when not null.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
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
              style: AppTextStyles.headingLarge,
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
}
