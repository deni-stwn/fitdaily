import 'dart:ui';

import 'package:flutter/material.dart';

/// Figma effect style "Button Effect" (3 INNER shadows) — buttons, quote card.
const buttonEffect = [
  BoxShadow(color: Color(0x80000000), offset: Offset(-2, -2), blurRadius: 6),
  BoxShadow(color: Color(0x26000000), offset: Offset(0, 32), blurRadius: 16),
  BoxShadow(color: Color(0x33FFFFFF), offset: Offset(2, 2), blurRadius: 2),
];

/// Oval with a Figma *layer blur* (blur ≈ 2 × sigma): button glow, light
/// spots.
class BlurredEllipse extends StatelessWidget {
  const BlurredEllipse({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.blur,
  });

  final double width;
  final double height;
  final Color color;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final sigma = blur / 2;
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(color: color, shape: const OvalBorder()),
      ),
    );
  }
}

/// Paints the fill plus Figma INNER_SHADOW effects, which [BoxShadow]
/// cannot express.
class InnerShadowPainter extends CustomPainter {
  const InnerShadowPainter({
    required this.color,
    required this.border,
    required this.radius,
    required this.shadows,
  });

  final Color? color;
  final BorderSide? border;
  final BorderRadius radius;
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = radius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);
    if (color != null) canvas.drawRRect(rrect, Paint()..color = color!);
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
    if (border != null) {
      // Inside stroke.
      canvas.drawRRect(rrect.deflate(border!.width / 2), border!.toPaint());
    }
  }

  @override
  bool shouldRepaint(InnerShadowPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.border != border ||
      oldDelegate.radius != radius ||
      oldDelegate.shadows != shadows;
}
