import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/goal_item.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../domain/entities/training_session.dart';
import 'training_target_style.dart';

extension on TrainingTarget {
  String get titleKey => switch (this) {
    TrainingTarget.step => LocaleKeys.training_by_step,
    TrainingTarget.distance => LocaleKeys.training_by_distance,
    TrainingTarget.time => LocaleKeys.training_by_time,
    TrainingTarget.calories => LocaleKeys.training_by_calories,
  };

  String get descKey => switch (this) {
    TrainingTarget.step => LocaleKeys.training_by_step_desc,
    TrainingTarget.distance => LocaleKeys.training_by_distance_desc,
    TrainingTarget.time => LocaleKeys.training_by_time_desc,
    TrainingTarget.calories => LocaleKeys.training_by_calories_desc,
  };
}

/// Figma *Modal* · Choose Target (Set Target 683:53521): *Card* (padding
/// 20, gap 16) · header [target icon 32 · gap 8 · "Set Target" / subtitle
/// (gap 4)] · 4 [GoalItem] (gap 4).
class ChooseTargetSheet extends StatelessWidget {
  const ChooseTargetSheet({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final TrainingTarget selected;
  final ValueChanged<TrainingTarget> onSelect;

  @override
  Widget build(BuildContext context) {
    return GradientBorderCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s3.h,
        children: [
          Row(
            spacing: AppSpacing.s2.w,
            children: [
              SvgPicture.asset(
                'assets/icons/target_header.svg',
                width: 32.w,
                height: 32.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s1.h,
                  children: [
                    Text(
                      LocaleKeys.training_set_target.tr(context: context),
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      LocaleKeys.training_set_target_desc.tr(context: context),
                      style: AppTextStyles.bodySmallStrong.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            spacing: AppSpacing.s1.h,
            children: [
              for (final t in TrainingTarget.values)
                GoalItem(
                  icon: t.icon,
                  title: t.titleKey.tr(context: context),
                  description: t.descKey.tr(context: context),
                  selected: t == selected,
                  onTap: () => onSelect(t),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
