import 'package:flutter/material.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;
  static const double minScale = 1.0;
  static const double maxScale = 1.0;

  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final scale = mediaQuery.textScaler.scale(1).clamp(minScale, maxScale);

    // No global bottom padding: Figma screens are full-bleed, so each page
    // handles insets itself (SafeArea / bottom nav).
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(scale)),
      child: child,
    );
  }
}
