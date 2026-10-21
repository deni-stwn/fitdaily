import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_logo.dart';

import '../../../../shared/widgets/card_scaffold.dart';
import '../widgets/auth_illustrations.dart';
import '../widgets/sign_in_card.dart';

/// Figma: Auth - Sign In (683:53091).
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CardScaffold(
      header: const AppLogo(),
      headerTop: 32.55, // logo top 92.55 − status bar 60
      illustration: AuthIllustrations.person(left: 151),
      card: const SignInCard(),
    );
  }
}
