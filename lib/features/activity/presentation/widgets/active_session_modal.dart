import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../domain/entities/activity_overview.dart';
import 'session_header.dart';
import 'session_round_button.dart';
import '../../domain/entities/training_session.dart';
import 'training_modal.dart';
import 'training_target_style.dart';

/// Figma *Modal* · Active Session (Walking Session 683:53588): header ·
/// gap 16 · ["Distance Target" / "2.4" (`headingLarge`) + "/ 5km"] ·····
/// (or the step / time / calories equivalent)
/// [pause (brand) · gap 8 · finish (plain)].
class ActiveSessionModal extends StatelessWidget {
  const ActiveSessionModal({
    super.key,
    required this.type,
    required this.target,
    required this.currentValue,
    required this.targetValue,
    required this.paused,
    required this.onPauseToggle,
    required this.onFinish,
  });

  final TrainingType type;
  final TrainingTarget target;
  final double currentValue;
  final double targetValue;

  /// Paused: the brand button shows play (no design for this state).
  final bool paused;
  final VoidCallback onPauseToggle;
  final VoidCallback onFinish;

  static const pauseKey = ValueKey('training-pause');
  static const finishKey = ValueKey('training-finish');

  @override
  Widget build(BuildContext context) {
    return TrainingModal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s3.h,
        children: [
          SessionHeader(type: type),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s1.h,
                children: [
                  Text(
                    target.labelKey.tr(context: context),
                    style: AppTextStyles.bodyMedium,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end, // figma: max
                    spacing: AppSpacing.s1.w,
                    children: [
                      Text(
                        target.format(currentValue),
                        style: AppTextStyles.headingLarge,
                      ),
                      Text(
                        target.ofText(context, targetValue),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textStat,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.s2.w,
                children: [
                  SessionRoundButton(
                    key: pauseKey,
                    icon: paused
                        ? 'assets/icons/play.svg'
                        : 'assets/icons/pause.svg',
                    onPressed: onPauseToggle,
                  ),
                  SessionRoundButton(
                    key: finishKey,
                    icon: 'assets/icons/session_finish.svg',
                    variant: SessionRoundButtonVariant.plain,
                    onPressed: onFinish,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
