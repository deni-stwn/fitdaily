import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/card_scaffold.dart';
import '../widgets/auth_illustrations.dart';
import '../widgets/verification_card.dart';

/// Figma: Auth - Password Reset - Verif (683:53815).
class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CardScaffold(
      headerTop: 24, // title bar top 84 − status bar 60
      header: AppTitleBar(
        title: LocaleKeys.password_reset_verify_title.tr(context: context),
        onBack: context.pop,
      ),
      illustration: AuthIllustrations.lock('assets/images/lock_code.png'),
      card: const VerificationCard(),
    );
  }
}
