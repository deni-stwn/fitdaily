import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/form_card.dart';

/// Forgot Password form (figma: 683:53122).
class ForgotPasswordCard extends StatefulWidget {
  const ForgotPasswordCard({super.key});

  @override
  State<ForgotPasswordCard> createState() => _ForgotPasswordCardState();
}

class _ForgotPasswordCardState extends State<ForgotPasswordCard> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormCard(
      title: LocaleKeys.password_reset_forgot_title.tr(context: context),
      children: [
        AppTextField(
          label: LocaleKeys.password_reset_email.tr(context: context),
          hint: LocaleKeys.password_reset_email_hint.tr(context: context),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
        ),
        AppButton(
          label: LocaleKeys.password_reset_send_link.tr(context: context),
          fullWidth: true,
          onPressed: () => context.push(RouteNames.kPasswordResetVerifyPage),
        ),
      ],
    );
  }
}
