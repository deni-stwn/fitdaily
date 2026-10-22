import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma "BPM Info" / "Horizontal Info": value (`headingMedium`) and unit
/// (`bodySmall`, tertiary), gap 4, bottom aligned — e.g. "84 Bpm".
class ValueUnit extends StatelessWidget {
  const ValueUnit({
    super.key,
    required this.value,
    required this.unit,
    this.unitColor = AppColors.textTertiary,
  });

  final String value;
  final String unit;

  /// Activity Info uses `textUnit` (#8F8F8F).
  final Color unitColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end, // figma: align max
      spacing: AppSpacing.s1.w,
      children: [
        Text(value, style: AppTextStyles.headingMedium),
        Text(unit, style: AppTextStyles.bodySmall.copyWith(color: unitColor)),
      ],
    );
  }
}
