import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_dimens.dart';
import '../../../config/theme/app_text_styles.dart';

/// Figma *Graph* summary bars (Overview, 683:54172): N columns (gap 8),
/// bars in an 86-high area (radius 8, `bgSecondary`; the 1.5 outside
/// border has the card colour, so it is invisible), the selected bar in
/// [color]; label chip below (gap 8, padding 6/2,
/// selected chip `bgSecondary` + white text).
class SummaryBarChart extends StatelessWidget {
  const SummaryBarChart({
    super.key,
    required this.bars,
    required this.selectedIndex,
    required this.color,
    this.onSelect,
  });

  /// Bar heights in Figma px (area 86).
  final List<({String label, double height})> bars;
  final int selectedIndex;
  final Color color;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s2.w,
      children: [
        for (var i = 0; i < bars.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: onSelect == null ? null : () => onSelect!(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                spacing: AppSpacing.s2.h,
                children: [
                  SizedBox(
                    height: 86.h,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: double.infinity,
                        height: bars[i].height.h,
                        decoration: BoxDecoration(
                          color: i == selectedIndex
                              ? color
                              : AppColors.bgSecondary,
                          borderRadius: BorderRadius.circular(
                            AppRadius.medium.r,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: i == selectedIndex ? AppColors.bgSecondary : null,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      bars[i].label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: i == selectedIndex
                            ? AppColors.text
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
