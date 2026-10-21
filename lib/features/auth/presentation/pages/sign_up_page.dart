import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_logo.dart';

import '../../../../shared/widgets/card_scaffold.dart';
import '../widgets/auth_illustrations.dart';
import '../widgets/sign_up_card.dart';

/// Figma: Auth - Sign Up (683:53855). The illustration is mostly hidden
/// behind the taller card (only the head shows).
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CardScaffold(
      header: const AppLogo(),
      headerTop: 32.55, // logo top 92.55 − status bar 60
      illustration: AuthIllustrations.person(left: 148),
      card: const SignUpCard(),
    );
  }
}
