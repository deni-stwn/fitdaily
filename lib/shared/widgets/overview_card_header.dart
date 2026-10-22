import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import 'app_icon_button.dart';

/// Overview card header (Figma *Header*, 48 high): title (`headingMedium`)
/// and subtitle (`bodySmall`, tertiary, gap 4) with a 48 chevron-down
/// button — Step/Calories gauge card, Heartrate "Heart rate" card,
/// Fitness Condition / VO₂ Max chart card.
class OverviewCardHeader extends StatelessWidget {
  const OverviewCardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onAction,
  });

  final String title;
  final String subtitle;

  /// No action in the design yet.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s1.h,
            children: [
              Text(title, style: AppTextStyles.headingMedium),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        AppIconButton(
          icon: 'assets/icons/chevron_down.svg',
          filled: false,
          onPressed: onAction ?? () {},
        ),
      ],
    );
  }
}
