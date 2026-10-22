import 'dart:ui';

import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Figma "Blurred Effect" · *full* (`691:12270`): full-screen `#262626`
/// layer with a 4px background blur (sigma 2) behind modals. Opacity comes
/// from the instance (60% Set Target, 20% Target Reached).
class BlurredOverlay extends StatelessWidget {
  const BlurredOverlay({super.key, this.opacity = 0.6, this.onTap});

  final double opacity;

  /// Tap outside the modal (e.g. dismiss).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRect(
        child: BackdropFilter(
          // figma: background blur radius 4 ≈ sigma 2.
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: ColoredBox(
            color: AppColors.overlayScrim.withValues(alpha: opacity),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
