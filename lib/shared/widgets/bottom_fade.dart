import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';

/// Figma "Blurred Effect · bottom" (`691:12269`): 138 high, `bg` 0% → 100%
/// gradient with a *background blur*. In Figma the background blur follows
/// the fill opacity, so it is progressive: none at the top (content stays
/// sharp), full at the bottom. Flutter has no progressive blur → stacked
/// strips with increasing sigma. Max blur not in the export (tuned).
class BottomFade extends StatelessWidget {
  const BottomFade({super.key, this.height = 138});

  /// Figma height (bottom variant 138; Personal Info instance 192).
  final double height;

  static const _maxBlur = 10.0;
  static const _strips = 16;

  @override
  Widget build(BuildContext context) {
    final height = this.height.h;
    final strip = height / _strips;

    return IgnorePointer(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [
            for (var i = 1; i < _strips; i++)
              Positioned(
                left: 0,
                right: 0,
                top: strip * i,
                height: strip,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _maxBlur / 2 * i / (_strips - 1),
                      sigmaY: _maxBlur / 2 * i / (_strips - 1),
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x001E1E1E), AppColors.bg],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
