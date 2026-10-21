import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/form_card.dart';
import '../../../../shared/widgets/card_scaffold.dart';
import '../widgets/auth_illustrations.dart';

/// Figma: Auth - Password Reset - Success (683:53841).
/// No back button in the design → system back is disabled too.
class ResetSuccessPage extends StatelessWidget {
  const ResetSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CardScaffold(
        headerTop: 24,
        header: AppTitleBar(
          title: LocaleKeys.password_reset_success_title_bar.tr(
            context: context,
          ),
        ),
        illustration: AuthIllustrations.lock('assets/images/lock_check.png'),
        card: FormCard(
          title: LocaleKeys.password_reset_success_title.tr(context: context),
          subtitle: LocaleKeys.password_reset_success_message.tr(
            context: context,
          ),
          children: [
            AppButton(
              label: LocaleKeys.password_reset_back_to_login.tr(
                context: context,
              ),
              fullWidth: true,
              onPressed: () => context.go(RouteNames.kSignInPage),
            ),
          ],
        ),
      ),
    );
  }
}
