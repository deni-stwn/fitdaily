import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';

/// `prompt` + `action` row, e.g. "Already Had an account ? Sign In"
/// (Onboarding) or "Forgot your password ? Forgot Password" (Sign In).
class TextLinkPrompt extends StatelessWidget {
  const TextLinkPrompt({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
    this.actionStyle,
    this.promptColor = AppColors.textSecondary,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  /// Defaults to `bodyMedium` in `AppColors.text`.
  final TextStyle? actionStyle;

  /// Prompt text colour (Verification caption uses `textTertiary`).
  final Color promptColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s2.w,
      children: [
        Text(
          prompt,
          style: AppTextStyles.bodyMedium.copyWith(color: promptColor),
        ),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Text(action, style: actionStyle ?? AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}
