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
import '../../../../shared/widgets/text_link_prompt.dart';

/// Figma: Onboarding (683:53078).
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: AppBackground(
          child: Stack(
            children: [
              // Title sits at a fixed proportion of the full frame (top 392
              // of 956), independent of the status bar / safe area height.
              Positioned(
                top: 392.h,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 357.w,
                    child: Text(
                      LocaleKeys.onboarding_title.tr(context: context),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display,
                    ),
                  ),
                ),
              ),
              const SafeArea(child: _SafeContent()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo (below the status bar) and bottom actions (above the home bar).
class _SafeContent extends StatelessWidget {
  const _SafeContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32.55.h), // logo top 92.55 − status bar 60
        const AppLogo(),
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
        TextLinkPrompt(
          prompt: LocaleKeys.onboarding_have_account.tr(context: context),
          action: LocaleKeys.onboarding_sign_in.tr(context: context),
          onTap: () => context.push(RouteNames.kSignInPage),
        ),
        SizedBox(height: 12.h), // link bottom 910 → home bar 922
      ],
    );
  }
}
