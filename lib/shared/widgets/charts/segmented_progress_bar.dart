import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Figma *Segmented Progress Bar* (`614:6382`): pill segments, 9 high, gap 2.
/// [segments] widths are relative (Figma px). [height] 9 (Home) or 8
/// inside the level-scale track (`LevelScaleBar`).
class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({
    super.key,
    required this.segments,
    this.height = 9,
  });

  final List<({double width, Color color})> segments;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 2.w,
        children: [
          for (final s in segments)
            Expanded(
              flex: (s.width * 100).round(),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: s.color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
