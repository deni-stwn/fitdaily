import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma component "Checkbox" (`266:5647`) with its label.
///
/// Only `Variant=default` (unchecked) has a spec so far; the checked
/// (`active`) look needs `figma-code/_components/checkbox`, so [value]
/// toggles without a visual change for now.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        spacing: AppSpacing.s2.w,
        children: [
          // figma: box 24×24, radius 4, fill #1B1B1B, border 1 white, opacity 50%
          Opacity(
            opacity: 0.5,
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1B),
                border: Border.all(color: AppColors.text),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
