import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../widgets/sign_in_prompt.dart';

/// Figma: Onboarding (683:53078). Vertical offsets are measured from the
/// bottom of the 60px status bar in the 440×956 frame.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 32.55.h), // logo top 92.55 − status bar 60
                const AppLogo(),
                SizedBox(
                  height: 266.55.h,
                ), // title top 392 − logo bottom 125.45
                SizedBox(
                  width: 357.w,
                  child: Text(
                    LocaleKeys.onboarding_title.tr(context: context),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.display,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w), // figma: 20
                  child: AppButton(
                    label: LocaleKeys.onboarding_continue.tr(context: context),
                    fullWidth: true,
                    onPressed: () => context.push(RouteNames.kSignUpPage),
                  ),
                ),
                SizedBox(height: AppSpacing.s3.h),
                SignInPrompt(
                  onSignIn: () => context.push(RouteNames.kSignInPage),
                ),
                SizedBox(height: 12.h), // link bottom 910 → home bar 922
              ],
            ),
          ),
        ),
      ),
    );
  }
}
