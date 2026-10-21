import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma component "Input" · Variant=Dropdown (`254:2527`): value · 1×24
/// divider (`border`) · 16 · caret 24. Opens a menu with [options].
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> options;
  final String Function(T option) optionLabel;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s2.h,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        PopupMenuButton<T>(
          initialValue: value,
          onSelected: onChanged,
          color: AppColors.bgTertiary,
          itemBuilder: (context) => [
            for (final option in options)
              PopupMenuItem(
                value: option,
                child: Text(
                  optionLabel(option),
                  style: AppTextStyles.bodySmall,
                ),
              ),
          ],
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w),
            decoration: BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(AppRadius.large.r),
            ),
            child: Row(
              spacing: AppSpacing.s3.w,
              children: [
                Expanded(
                  child: Text(
                    optionLabel(value),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                // figma: divider measured from the screenshot (not in spec).
                Container(width: 1, height: 24.w, color: AppColors.border),
                SvgPicture.asset(
                  'assets/icons/caret_down.svg',
                  width: 24.w,
                  height: 24.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
