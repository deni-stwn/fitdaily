import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// "Already Had an account ? Sign In" (figma: 683:53078).
class SignInPrompt extends StatelessWidget {
  const SignInPrompt({super.key, required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.onboarding_have_account.tr(context: context),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: AppSpacing.s2.w),
        GestureDetector(
          onTap: onSignIn,
          behavior: HitTestBehavior.opaque,
          child: Text(
            LocaleKeys.onboarding_sign_in.tr(context: context),
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}
