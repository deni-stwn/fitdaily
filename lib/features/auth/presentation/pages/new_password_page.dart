import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/card_scaffold.dart';
import '../widgets/auth_illustrations.dart';
import '../widgets/new_password_card.dart';

/// Figma: Auth - Password Reset - Create new PW (683:53137).
/// No back button in the design → system back is disabled too.
class NewPasswordPage extends StatelessWidget {
  const NewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CardScaffold(
        headerTop: 24,
        header: AppTitleBar(
          title: LocaleKeys.password_reset_new_title_bar.tr(context: context),
        ),
        illustration: AuthIllustrations.lock(
          'assets/images/lock_open.png',
          height: 184,
        ),
        card: const NewPasswordCard(),
      ),
    );
  }
}
