import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// Variant of the Figma *Input* component.
enum AppTextFieldVariant {
  /// Single line, 48 high.
  standard,

  /// Multi-line, fixed height (Goals commitment 175), text top-aligned,
  /// padding 16/8/16/16 (figma: 683:54754).
  textarea,
}

/// Figma component "Input" (`254:2529`).
///
/// Specs so far: `Variant=Default · State=Default` (02-auth_sign_in) and the
/// unit suffix (09-user-setup-goal). Active/Error states and Textarea need
/// `figma-code/_components/input`. Dropdown → `AppDropdownField`.
///
/// Search field (31-devices-faq, 683:54678): no [label] (label container
/// hidden), `hint: 'Search'`, [suffix] 24 search icon, [onChanged].
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
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
    this.variant = AppTextFieldVariant.standard,
    this.textareaHeight = 175,
    this.onChanged,
  });

  /// Label above the field; null hides it (search field).
  final String? label;
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

  final AppTextFieldVariant variant;

  /// Box height of [AppTextFieldVariant.textarea] (Figma px).
  final double textareaHeight;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textarea = variant == AppTextFieldVariant.textarea;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s2.h,
      children: [
        if (label != null)
          Text(
            label!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        Container(
          height: textarea ? textareaHeight.h : 48.h,
          padding: textarea
              ? EdgeInsets.fromLTRB(
                  AppSpacing.s3.w,
                  AppSpacing.s3.h,
                  AppSpacing.s2.w,
                  AppSpacing.s3.h,
                )
              : EdgeInsets.symmetric(horizontal: AppSpacing.s3.w),
          decoration: BoxDecoration(
            color: AppColors.bgTertiary,
            borderRadius: BorderRadius.circular(AppRadius.large.r),
          ),
          child: Row(
            crossAxisAlignment: textarea
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.center,
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
                  onChanged: onChanged,
                  showCursor: !readOnly,
                  maxLines: textarea ? null : 1,
                  expands: textarea,
                  // Typed text colour is not in the spec yet (Active state).
                  style: AppTextStyles.bodySmall,
                  textAlignVertical: textarea
                      ? TextAlignVertical.top
                      : TextAlignVertical.center,
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
