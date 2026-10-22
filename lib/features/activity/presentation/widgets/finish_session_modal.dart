import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/activity_info_tile.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/activity_overview.dart';
import 'training_modal.dart';
import 'training_type_style.dart';

/// Figma *Modal* · Finish Session (Target Reached 683:53639): padding 16,
/// gap 16 · message (16/24 SemiBold) + close · *Activity Info* · [Continue
/// training (secondary) · gap 8 · Stop training (primary)].
class FinishSessionModal extends StatelessWidget {
  const FinishSessionModal({
    super.key,
    required this.summary,
    required this.distanceKm,
    required this.onClose,
    required this.onContinue,
    required this.onStop,
  });

  final TrainingRecord summary;
  final double distanceKm;
  final VoidCallback onClose;
  final VoidCallback onContinue;
  final VoidCallback onStop;

  static const stopKey = ValueKey('training-stop');

  @override
  Widget build(BuildContext context) {
    return TrainingModal(
      padding: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s3.h,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: AppSpacing.s2.w,
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.training_congratulation.tr(context: context),
                  // figma: 16/24 Semi Bold (no token) → body/large/strong.
                  style: AppTextStyles.bodyLargeStrong,
                ),
              ),
              GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  'assets/icons/close_tertiary.svg',
                  width: 24.w,
                  height: 24.w,
                ),
              ),
            ],
          ),
          ActivityInfoTile(
            icon: summary.type.sessionIcon,
            title: summary.title,
            stats: [summary.duration, summary.calories, summary.date],
            value: formatKm(distanceKm),
            unit: summary.unit,
          ),
          Row(
            spacing: AppSpacing.s2.w,
            children: [
              Expanded(
                child: AppButton(
                  label: LocaleKeys.training_continue_training.tr(
                    context: context,
                  ),
                  variant: AppButtonVariant.secondary,
                  fullWidth: true,
                  onPressed: onContinue,
                ),
              ),
              Expanded(
                child: AppButton(
                  key: stopKey,
                  label: LocaleKeys.training_stop_training.tr(context: context),
                  fullWidth: true,
                  onPressed: onStop,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
