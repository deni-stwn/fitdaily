import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../config/routing/route_names.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import '../../generated/locale_keys.g.dart';
import 'app_button.dart';
import 'card_scaffold.dart';
import 'form_card.dart';

/// Setup-style screen (User Setup, Device Setup): illustration, bottom
/// [FormCard] with title + subtitle, [children], then the action block
/// (primary button · optional "Setup Later" → Home · caption).
class SetupScaffold extends StatelessWidget {
  const SetupScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.primaryLabel,
    required this.onPrimary,
    required this.illustration,
    this.showSetupLater = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final CardIllustration illustration;
  final bool showSetupLater;

  @override
  Widget build(BuildContext context) {
    return CardScaffold(
      illustration: illustration,
      card: FormCard(
        title: title,
        subtitle: subtitle,
        children: [
          ...children,
          Column(
            spacing: AppSpacing.s2.h,
            children: [
              AppButton(
                label: primaryLabel,
                fullWidth: true,
                onPressed: onPrimary,
              ),
              if (showSetupLater)
                AppButton(
                  label: LocaleKeys.user_setup_setup_later.tr(context: context),
                  variant: AppButtonVariant.outline,
                  fullWidth: true,
                  onPressed: () => context.go(RouteNames.kRootPage),
                ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  LocaleKeys.user_setup_caption.tr(context: context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
