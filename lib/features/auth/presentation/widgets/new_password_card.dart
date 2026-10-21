import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_password_field.dart';
import '../../../../shared/widgets/form_card.dart';

/// Create New Password form (figma: 683:53137).
class NewPasswordCard extends StatefulWidget {
  const NewPasswordCard({super.key});

  @override
  State<NewPasswordCard> createState() => _NewPasswordCardState();
}

class _NewPasswordCardState extends State<NewPasswordCard> {
  final _passwordController = TextEditingController();
  final _verifyController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _verifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hint = LocaleKeys.password_reset_password_hint.tr(context: context);

    return FormCard(
      title: LocaleKeys.password_reset_new_title.tr(context: context),
      // figma: both fields are direct card children (gap 24, not 16).
      children: [
        AppPasswordField(
          label: LocaleKeys.password_reset_new_password.tr(context: context),
          hint: hint,
          controller: _passwordController,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
        ),
        AppPasswordField(
          label: LocaleKeys.password_reset_verify_new_password.tr(
            context: context,
          ),
          hint: hint,
          controller: _verifyController,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
        ),
        AppButton(
          label: LocaleKeys.password_reset_reset_button.tr(context: context),
          fullWidth: true,
          onPressed: () =>
              context.pushReplacement(RouteNames.kPasswordResetSuccessPage),
        ),
      ],
    );
  }
}
