import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Figma *Segmented Progress Bar* (`614:6382`): pill segments, 9 high, gap 2.
/// [segments] widths are relative (Figma px).
class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({super.key, required this.segments});

  final List<({double width, Color color})> segments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 9.h,
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
