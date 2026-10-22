import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/gradient_border_card.dart';

/// Entries of the Training History option menu.
enum TrainingHistoryOption { filterSort, shareReport, delete }

/// Shows the option menu (Figma *Card* 696:12093 "Option": 158 wide at
/// x 260 / y 123 of the frame, under the title bar "more" button) without
/// a scrim. Resolves to the chosen entry (null when dismissed).
Future<TrainingHistoryOption?> showTrainingHistoryOptionMenu(
  BuildContext context,
) {
  return showGeneralDialog<TrainingHistoryOption>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.transparent,
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, _, _) => Stack(
      children: [
        Positioned(
          // figma: y 123 − status bar 60 (SafeArea), right 440 − 418.
          top: MediaQuery.paddingOf(context).top + 63.h,
          right: 22.w,
          child: const TrainingHistoryOptionMenu(),
        ),
      ],
    ),
    transitionBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// Option card: padding 12, three 32-high text buttons (gap 4), label
/// 12 Medium `textSecondary` with 16 leading inset (8 + 8).
class TrainingHistoryOptionMenu extends StatelessWidget {
  const TrainingHistoryOptionMenu({super.key});

  static const _labels = {
    TrainingHistoryOption.filterSort: LocaleKeys.training_history_filter_sort,
    TrainingHistoryOption.shareReport: LocaleKeys.training_history_share_report,
    TrainingHistoryOption.delete: LocaleKeys.training_history_delete,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        width: 158.w,
        child: GradientBorderCard(
          padding: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s1.h,
            children: [
              for (final MapEntry(:key, :value) in _labels.entries)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(key),
                  child: Container(
                    height: 32.h,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      value.tr(context: context),
                      style: AppTextStyles.bodySmallStrong.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
