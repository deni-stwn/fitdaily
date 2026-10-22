import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/section_header.dart';

/// "Weekly Goals" / "Total Goals" card (683:53318): title · 7 bars (50 high)
/// · "80%" `headingLarge` + "Complete" · caption. [wideBars]: bars fill the
/// width with gap 4 (Weekly); otherwise 8 wide, space-between (Total).
class GoalSummaryCard extends StatelessWidget {
  const GoalSummaryCard({
    super.key,
    required this.title,
    required this.percent,
    required this.bars,
    required this.completeLabel,
    required this.caption,
    this.wideBars = false,
  });

  final String title;
  final int percent;

  /// Fill heights in Figma px (track 50).
  final List<double> bars;
  final String completeLabel;
  final String caption;
  final bool wideBars;

  @override
  Widget build(BuildContext context) {
    final tertiary = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textTertiary,
    );
    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s3.h,
        children: [
          // Header with its button hidden → title only (18 high).
          SectionHeader(title: title, trailing: const SizedBox.shrink()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: wideBars ? AppSpacing.s1.w : 0,
            children: [
              for (final b in bars)
                wideBars
                    ? Expanded(child: _GoalBar(fill: b))
                    : SizedBox(
                        width: 8.w,
                        child: _GoalBar(fill: b),
                      ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2.h,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end, // figma: max
                spacing: AppSpacing.s1.w,
                children: [
                  Text('$percent%', style: AppTextStyles.headingLarge),
                  Text(completeLabel, style: tertiary),
                ],
              ),
              Text(caption, style: tertiary),
            ],
          ),
        ],
      ),
    );
  }
}

/// Track 50 high (`bgSecondary`, radius 50) with a bottom-aligned
/// `goalBar` fill (1.5 `bg` stroke outside).
class _GoalBar extends StatelessWidget {
  const _GoalBar({required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(50),
      ),
      child: fill <= 0
          ? null
          : Container(
              height: fill.h,
              decoration: BoxDecoration(
                color: AppColors.goalBar,
                border: Border.all(
                  color: AppColors.bg,
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
    );
  }
}
