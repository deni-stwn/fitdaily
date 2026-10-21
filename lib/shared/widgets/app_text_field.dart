import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Figma component "Input" (`254:2529`).
///
/// Specs so far: `Variant=Default · State=Default` (02-auth_sign_in) and the
/// unit suffix (09-user-setup-goal). Active/Error states and Textarea need
/// `figma-code/_components/input`. Dropdown → `AppDropdownField`.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.suffix,
    this.suffixText,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;

  /// Trailing widget inside the field (e.g. 24×24 eye icon).
  final Widget? suffix;

  /// Unit on the right (Figma Input · prefix): "Kg", "Hours"… in
  /// `bodyMedium` `textTertiary`.
  final String? suffixText;

  /// For picker-driven fields (time): no keyboard, [onTap] opens the picker.
  final bool readOnly;
  final VoidCallback? onTap;

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
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w),
          decoration: BoxDecoration(
            color: AppColors.bgTertiary,
            borderRadius: BorderRadius.circular(AppRadius.large.r),
          ),
          child: Row(
            spacing: 10.w, // figma: 10
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  textCapitalization: textCapitalization,
                  autofillHints: autofillHints,
                  readOnly: readOnly,
                  onTap: onTap,
                  showCursor: !readOnly,
                  // Typed text colour is not in the spec yet (Active state).
                  style: AppTextStyles.bodySmall,
                  textAlignVertical: TextAlignVertical.center,
                  // The container above is the whole field; switch off every
                  // part of the global InputDecorationTheme (fill, borders,
                  // padding) or it draws a second, smaller box when focused.
                  decoration: InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: hint,
                    hintStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              if (suffixText != null)
                Text(
                  suffixText!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ?suffix,
            ],
          ),
        ),
      ],
    );
  }
}
