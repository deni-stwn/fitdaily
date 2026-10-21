import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

/// Figma *Legend Item* (`612:6138`): 4px dot + label (10/w500), then value
/// (`bodyMedium`) + unit (8px `textTertiary`), gap 10.
class LegendItem extends StatelessWidget {
  const LegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.value,
    required this.unit,
  });

  final Color color;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.h,
      children: [
        SizedBox(
          height: 10.h,
          child: Row(
            spacing: 8.w,
            children: [
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10.sp, // figma: 10 / w500 (no text style)
                  height: 1,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                  fontVariations: const [FontVariation.weight(500)],
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end, // figma
          spacing: 2.w,
          children: [
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(letterSpacing: 0.5),
            ),
            Text(
              unit,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 8.sp,
                height: 1,
                letterSpacing: 0,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
