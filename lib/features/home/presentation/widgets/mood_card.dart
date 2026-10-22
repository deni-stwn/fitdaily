import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/entities/home_dashboard.dart';

/// Home "Mood" card (figma: 10871 in Home 683:53154): fixed 208×234,
/// header (icon · title · chevron), 64 mood icon, label + caption.
class MoodCard extends StatelessWidget {
  const MoodCard({super.key, required this.mood, this.onMore});

  final MoodSummary mood;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 234.h, // figma: fixed height
      child: GradientBorderCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s3.h,
          children: [
            SectionHeader(
              icon: 'assets/icons/metric_mood.svg',
              title: LocaleKeys.home_mood.tr(context: context),
              // Chevron is always drawn (like the Steps/Calories cards).
              onAction: onMore ?? () {},
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2.h,
              children: [
                SvgPicture.asset(
                  'assets/icons/mood_good.svg',
                  width: 64.w,
                  height: 64.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s2.h,
                  children: [
                    Text(mood.label, style: AppTextStyles.headingLarge),
                    Text(
                      mood.message,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
