import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import 'brand_effects.dart';

/// Figma component "Button" (`84:348`) — `Variant` property.
enum AppButtonVariant { primary, secondary, outline, tertiary }

/// Figma component "Button" (`84:348`) — `sizes` property.
enum AppButtonSize { large, medium, small }

/// Figma "Button". Specs so far (all `sizes=Large`): Default (01-onboarding),
/// Secondary + leading icon (10 goal chips), Outline (09 "Setup Later"),
/// Secondary small (18 "Full Report").
/// Other combinations throw until `figma-code/_components/button` is
/// exported.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.fullWidth = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Stretch to the parent's width (Figma instance resized to "Fill").
  final bool fullWidth;

  /// Optional 24×24 leading icon (e.g. goal chips), 8 before the label.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final spec = _ButtonSpec.of(variant, size);
    final radius = BorderRadius.circular(AppRadius.full);

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: spec.height.h,
          width: fullWidth ? double.infinity : null,
          child: CustomPaint(
            painter: InnerShadowPainter(
              color: spec.background,
              border: spec.border,
              radius: radius,
              shadows: spec.innerShadows,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (icon == null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: spec.horizontalPadding.w,
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: spec.labelStyle,
                    ),
                  )
                else
                  // figma: padding 16 · icon 24 · label with 8 each side.
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 24.w, height: 24.w, child: icon),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.s2.w,
                          ),
                          child: Text(label, style: spec.labelStyle),
                        ),
                      ],
                    ),
                  ),
                if (spec.glow != null)
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final width = box.maxWidth * spec.glow!.widthFactor;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: spec.glow!.top.h,
                              left: (box.maxWidth - width) / 2,
                              child: BlurredEllipse(
                                width: width,
                                height: spec.glow!.height.h,
                                color: spec.glow!.color,
                                blur: spec.glow!.blur,
                              ),
                            ),
                          ],
                        );
                      },
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

class _ButtonSpec {
  const _ButtonSpec({
    required this.height,
    required this.horizontalPadding,
    required this.labelStyle,
    this.background,
    this.border,
    this.innerShadows = const [],
    this.glow,
  });

  final double height;
  final double horizontalPadding;
  final Color? background;
  final BorderSide? border;
  final TextStyle labelStyle;
  final List<BoxShadow> innerShadows;
  final _GlowSpec? glow;

  static _ButtonSpec of(AppButtonVariant variant, AppButtonSize size) {
    if (variant == AppButtonVariant.primary && size == AppButtonSize.large) {
      return _ButtonSpec(
        height: 48,
        // figma: padding 16 + label container padding 8
        horizontalPadding: AppSpacing.s3 + AppSpacing.s2,
        background: AppColors.bgBrand,
        labelStyle: AppTextStyles.bodySmallStrong,
        innerShadows: buttonEffect,
        glow: const _GlowSpec(
          // Figma: 139.13 on a 400 button, 130.78 on 376 → 34.78% of width.
          widthFactor: 139.13 / 400,
          height: 14,
          top: -7,
          color: AppColors.textSecondary,
          // Approximation tuned against the Figma screenshot: blur value
          // was not in the export (review 01-onboarding).
          blur: 20,
        ),
      );
    }
    if (size == AppButtonSize.large) {
      switch (variant) {
        // 10-user-setup-goal-2: unselected goal chips.
        case AppButtonVariant.secondary:
          return _ButtonSpec(
            height: 48,
            horizontalPadding: AppSpacing.s3 + AppSpacing.s2,
            background: AppColors.white200,
            labelStyle: AppTextStyles.bodySmallStrong,
          );
        // 09-user-setup-goal: "Setup Later".
        case AppButtonVariant.outline:
          return _ButtonSpec(
            height: 48,
            horizontalPadding: AppSpacing.s3 + AppSpacing.s2,
            border: const BorderSide(color: AppColors.white200),
            labelStyle: AppTextStyles.bodySmallStrong.copyWith(
              color: AppColors.textTertiary,
            ),
          );
        case AppButtonVariant.primary:
        case AppButtonVariant.tertiary:
          break;
      }
    }
    // 18-home: "Full Report".
    if (variant == AppButtonVariant.secondary && size == AppButtonSize.small) {
      return _ButtonSpec(
        height: 32,
        horizontalPadding: AppSpacing.s2 + AppSpacing.s2,
        background: AppColors.white200,
        labelStyle: AppTextStyles.bodySmallStrong,
      );
    }
    throw UnimplementedError(
      'AppButton $variant/$size: no Figma spec yet — export '
      'figma-code/_components/button first.',
    );
  }
}

class _GlowSpec {
  const _GlowSpec({
    required this.widthFactor,
    required this.height,
    required this.top,
    required this.color,
    required this.blur,
  });

  /// Glow width as a fraction of the button width.
  final double widthFactor;
  final double height;
  final double top;
  final Color color;
  final double blur;
}
