import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import 'app_pill_icon_button.dart';

/// Figma component "Accordion" (`652:32627`): Open · Close.
///
/// `bg`, radius 8, 1px border `white200` → `white100` (top → bottom).
/// Header: optional 24 [icon] · gap 8 · title (`bodyMedium`) ··· chevron
/// pill button (36×44). *Open*: padding 20, gap 8, answer `bodySmall`
/// `textSecondary`. *Close*: padding 8/20, answer hidden (FAQ 683:54678).
class AppAccordion extends StatelessWidget {
  const AppAccordion({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.expanded = false,
    this.onToggle,
  });

  final String title;
  final String content;

  /// Leading 24 icon asset (e.g. `add_circle.svg`); null hides it.
  final String? icon;

  /// *Open* when true, *Close* otherwise.
  final bool expanded;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.medium.r);
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(1), // 1px gradient border
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.white200, AppColors.white100],
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: (20 - 1).w, // figma: 20
            vertical: ((expanded ? 20 : AppSpacing.s2) - 1).h,
          ),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(AppRadius.medium.r - 1),
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.s2.h,
              children: [
                Row(
                  spacing: AppSpacing.s2.w,
                  children: [
                    if (icon != null)
                      SvgPicture.asset(icon!, width: 24.w, height: 24.w),
                    Expanded(
                      child: Text(title, style: AppTextStyles.bodyMedium),
                    ),
                    AppPillIconButton(
                      icon: 'assets/icons/accordion_chevron.svg',
                      onPressed: onToggle,
                    ),
                  ],
                ),
                if (expanded)
                  Text(
                    content,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
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
