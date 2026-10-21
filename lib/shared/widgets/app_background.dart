import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Shared screen background: `AppColors.bg` + diamond pattern fading
/// downwards (figma: layer "Background", 440×956). Not every screen uses it.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  static const _patternAsset = 'assets/images/bg_pattern.png';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _patternAsset,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
