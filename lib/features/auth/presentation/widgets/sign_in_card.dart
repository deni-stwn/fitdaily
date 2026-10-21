import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_checkbox.dart';
import '../../../../shared/widgets/app_password_field.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/text_link_prompt.dart';
import '../../../../shared/widgets/form_card.dart';

/// Sign In form (figma: 683:53091).
class SignInCard extends StatefulWidget {
  const SignInCard({super.key});

  @override
  State<SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends State<SignInCard> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormCard(
      title: LocaleKeys.sign_in_title.tr(context: context),
      children: [
        Column(
          spacing: AppSpacing.s3.h,
          children: [
            AppTextField(
              label: LocaleKeys.sign_in_email.tr(context: context),
              hint: LocaleKeys.sign_in_email_hint.tr(context: context),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
            ),
            AppPasswordField(
              label: LocaleKeys.sign_in_password.tr(context: context),
              hint: LocaleKeys.sign_in_password_hint.tr(context: context),
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
            ),
          ],
        ),
        AppCheckbox(
          value: _rememberMe,
          onChanged: (value) => setState(() => _rememberMe = value),
          label: LocaleKeys.sign_in_remember_me.tr(context: context),
        ),
        Column(
          spacing: AppSpacing.s3.h,
          children: [
            AppButton(
              label: LocaleKeys.sign_in_button.tr(context: context),
              fullWidth: true,
              onPressed: () => context.go(RouteNames.kRootPage),
            ),
            TextLinkPrompt(
              prompt: LocaleKeys.sign_in_forgot_prompt.tr(context: context),
              action: LocaleKeys.sign_in_forgot_action.tr(context: context),
              actionStyle: AppTextStyles.bodySmallStrong.copyWith(
                fontStyle: FontStyle.italic,
              ),
              onTap: () => context.push(RouteNames.kPasswordResetPage),
            ),
            // Not in Figma (user request): mirrors Sign Up's "Login" link.
            TextLinkPrompt(
              prompt: LocaleKeys.sign_in_no_account.tr(context: context),
              action: LocaleKeys.sign_in_sign_up.tr(context: context),
              actionStyle: AppTextStyles.bodySmallStrong.copyWith(
                fontStyle: FontStyle.italic,
              ),
              onTap: () => context.pushReplacement(RouteNames.kSignUpPage),
            ),
          ],
        ),
      ],
    );
  }
}
