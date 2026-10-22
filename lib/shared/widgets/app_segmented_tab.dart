import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma component "Tab" (`598:31871`, 2 & 3 columns): 36-high capsule
/// (`bg`, 1px border ≈ white 15% measured — "Diagonal Border" not
/// exported), equal items 32 high; the active item is a `white200` pill
/// that slides between items (animation not in Figma).
class AppSegmentedTab extends StatelessWidget {
  const AppSegmentedTab({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border.all(color: const Color(0x26FFFFFF)),
        borderRadius: BorderRadius.circular(99),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final itemWidth = box.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: _duration,
                curve: Curves.easeOutCubic,
                left: itemWidth * selectedIndex,
                width: itemWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onChanged(i),
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: _duration,
                            style: AppTextStyles.bodySmallStrong.copyWith(
                              color: i == selectedIndex
                                  ? AppColors.text
                                  : AppColors.textDisabled,
                            ),
                            child: Text(labels[i]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
