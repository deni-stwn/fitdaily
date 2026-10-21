import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_password_field.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/text_link_prompt.dart';
import '../../../../shared/widgets/form_card.dart';
import 'social_login_button.dart';

/// Sign Up form (figma: 683:53855).
class SignUpCard extends StatefulWidget {
  const SignUpCard({super.key});

  @override
  State<SignUpCard> createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verifyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _verifyController.dispose();
    super.dispose();
  }

  void _continue() => context.go(RouteNames.kUserSetupPage);

  @override
  Widget build(BuildContext context) {
    final passwordHint = LocaleKeys.sign_up_password_hint.tr(context: context);

    return FormCard(
      title: LocaleKeys.sign_up_title.tr(context: context),
      children: [
        Column(
          spacing: AppSpacing.s3.h,
          children: [
            AppTextField(
              label: LocaleKeys.sign_up_full_name.tr(context: context),
              hint: LocaleKeys.sign_up_full_name_hint.tr(context: context),
              controller: _nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
            ),
            AppTextField(
              label: LocaleKeys.sign_up_email.tr(context: context),
              hint: LocaleKeys.sign_up_email_hint.tr(context: context),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
            ),
            AppPasswordField(
              label: LocaleKeys.sign_up_new_password.tr(context: context),
              hint: passwordHint,
              controller: _passwordController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
            ),
            AppPasswordField(
              label: LocaleKeys.sign_up_verify_password.tr(context: context),
              hint: passwordHint,
              controller: _verifyController,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
            ),
          ],
        ),
        Column(
          spacing: AppSpacing.s3.h,
          children: [
            AppButton(
              label: LocaleKeys.sign_up_button.tr(context: context),
              fullWidth: true,
              onPressed: _continue,
            ),
            Text(
              LocaleKeys.sign_up_or.tr(context: context),
              style: AppTextStyles.bodyMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppSpacing.s2.w,
              children: [
                for (final provider in SocialProvider.values)
                  SocialLoginButton(provider: provider, onPressed: _continue),
              ],
            ),
            TextLinkPrompt(
              prompt: LocaleKeys.sign_up_have_account.tr(context: context),
              action: LocaleKeys.sign_up_login.tr(context: context),
              actionStyle: AppTextStyles.bodySmallStrong.copyWith(
                fontStyle: FontStyle.italic,
              ),
              onTap: () => context.pushReplacement(RouteNames.kSignInPage),
            ),
          ],
        ),
      ],
    );
  }
}
