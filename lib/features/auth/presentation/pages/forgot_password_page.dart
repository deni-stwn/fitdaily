import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/card_scaffold.dart';
import '../widgets/auth_illustrations.dart';
import '../widgets/forgot_password_card.dart';

/// Figma: Auth - Password Reset (683:53122).
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CardScaffold(
      headerTop: 24, // title bar top 84 − status bar 60
      header: AppTitleBar(
        title: LocaleKeys.password_reset_forgot_title.tr(context: context),
        onBack: context.pop,
      ),
      illustration: AuthIllustrations.lock(
        'assets/images/lock_question.png',
        top: 289,
      ),
      card: const ForgotPasswordCard(),
    );
  }
}
