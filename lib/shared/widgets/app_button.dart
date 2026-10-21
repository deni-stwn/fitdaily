import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma component "Button" (`84:348`) — `Variant` property.
enum AppButtonVariant { primary, secondary, outline, tertiary }

/// Figma component "Button" (`84:348`) — `sizes` property.
enum AppButtonSize { large, medium, small }

/// Figma "Button". Only `Variant=Default · sizes=Large` has a spec so far
/// (from 01-onboarding); other combinations throw until
/// `figma-code/_components/button` is exported.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Stretch to the parent's width (Figma instance resized to "Fill").
  final bool fullWidth;

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
            painter: _InnerShadowPainter(
              color: spec.background,
              radius: radius,
              shadows: spec.innerShadows,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spec.horizontalPadding.w,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: spec.labelStyle,
                  ),
                ),
                if (spec.glow != null)
                  Positioned(top: spec.glow!.top.h, child: _Glow(spec.glow!)),
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
    required this.background,
    required this.labelStyle,
    required this.innerShadows,
    this.glow,
  });

  final double height;
  final double horizontalPadding;
  final Color background;
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
        innerShadows: _buttonEffect,
        glow: const _GlowSpec(
          width: 139.13,
          height: 14,
          top: -7,
          color: AppColors.textSecondary,
          // Approximation tuned against the Figma screenshot: blur value
          // was not in the export (review 01-onboarding).
          blur: 20,
        ),
      );
    }
    throw UnimplementedError(
      'AppButton $variant/$size: no Figma spec yet — export '
      'figma-code/_components/button first.',
    );
  }

  /// Figma effect style "Button Effect" (see [AppShadows.buttonEffectSpec]).
  static const _buttonEffect = [
    BoxShadow(color: Color(0x80000000), offset: Offset(-2, -2), blurRadius: 6),
    BoxShadow(color: Color(0x26000000), offset: Offset(0, 32), blurRadius: 16),
    BoxShadow(color: Color(0x33FFFFFF), offset: Offset(2, 2), blurRadius: 2),
  ];
}

class _GlowSpec {
  const _GlowSpec({
    required this.width,
    required this.height,
    required this.top,
    required this.color,
    required this.blur,
  });

  final double width;
  final double height;
  final double top;
  final Color color;
  final double blur;
}

class _Glow extends StatelessWidget {
  const _Glow(this.spec);

  final _GlowSpec spec;

  @override
  Widget build(BuildContext context) {
    // Figma layer blur ≈ 2 × sigma.
    final sigma = spec.blur / 2;
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        width: spec.width.w,
        height: spec.height.h,
        decoration: ShapeDecoration(
          color: spec.color,
          shape: const OvalBorder(),
        ),
      ),
    );
  }
}

/// Paints the fill plus Figma INNER_SHADOW effects, which [BoxShadow]
/// cannot express.
class _InnerShadowPainter extends CustomPainter {
  const _InnerShadowPainter({
    required this.color,
    required this.radius,
    required this.shadows,
  });

  final Color color;
  final BorderRadius radius;
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = radius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRRect(rrect, Paint()..color = color);
    for (final shadow in shadows) {
      final paint = Paint()
        ..color = shadow.color
        // Figma blur radius ≈ 2 × sigma.
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius / 2);
      final path = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(rect.inflate(shadow.blurRadius + shadow.offset.distance + 1))
        ..addRRect(rrect.shift(shadow.offset));
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InnerShadowPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.shadows != shadows;
}
