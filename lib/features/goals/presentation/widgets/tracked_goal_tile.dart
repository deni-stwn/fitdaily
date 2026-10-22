import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../domain/entities/goals_overview.dart';
import 'goal_type_ui.dart';

/// Weekly Goals row (Figma *Menu Item*, 683:53318): pill `bgSecondary`,
/// padding 16, space-between: name (70) · tracking (120) · chip (80) · ⋮.
class TrackedGoalTile extends StatelessWidget {
  const TrackedGoalTile({super.key, required this.goal, this.onDelete});

  final TrackedGoal goal;

  /// "⋮" menu → Delete (no design for the menu).
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.s3.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 70.w, // figma
            child: Text(
              goal.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmallStrong,
            ),
          ),
          SizedBox(
            width: 120.w, // figma
            child: Text(
              goal.tracking,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          StatusChip(
            label: goal.status.labelKey.tr(context: context),
            variant: goal.status.chipVariant,
            width: 80, // figma
            // figma: instances use text style 12/16 (→ chip 32 high).
            textStyle: AppTextStyles.bodySmallStrong,
          ),
          PopupMenuButton<int>(
            padding: EdgeInsets.zero,
            color: AppColors.bgTertiary,
            onSelected: (_) => onDelete?.call(),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  LocaleKeys.goals_delete.tr(context: context),
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
            child: SvgPicture.asset(
              'assets/icons/more_vertical.svg',
              width: 24.w,
              height: 24.w,
            ),
          ),
        ],
      ),
    );
  }
}
