import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/text_link_prompt.dart';
import '../../../../shared/widgets/form_card.dart';
import 'otp_input.dart';

/// Verification code form (figma: 683:53815).
class VerificationCard extends StatefulWidget {
  const VerificationCard({super.key});

  @override
  State<VerificationCard> createState() => _VerificationCardState();
}

class _VerificationCardState extends State<VerificationCard> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormCard(
      title: LocaleKeys.password_reset_verify_title.tr(context: context),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s2.h,
          children: [
            OtpInput(controller: _codeController),
            TextLinkPrompt(
              prompt: LocaleKeys.password_reset_verify_check.tr(
                context: context,
              ),
              promptColor: AppColors.textTertiary,
              action: LocaleKeys.password_reset_verify_resend.tr(
                context: context,
              ),
              actionStyle: AppTextStyles.bodySmallStrong,
              // No backend: "resend" just clears the boxes.
              onTap: _codeController.clear,
            ),
          ],
        ),
        AppButton(
          label: LocaleKeys.password_reset_confirm.tr(context: context),
          fullWidth: true,
          onPressed: () =>
              context.pushReplacement(RouteNames.kPasswordResetNewPage),
        ),
      ],
    );
  }
}
