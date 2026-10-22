import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/activity_overview.dart';
import 'session_header.dart';
import 'session_round_button.dart';
import '../../domain/entities/training_session.dart';
import 'training_modal.dart';
import 'training_target_style.dart';

/// Figma *Modal* · Start Session (683:53476, 683:54595): header · gap 16 ·
/// [target pill (fill, 56, `bgSecondary`, border `border`) · gap 8 · play].
/// Without a target the pill reads "Choose how you track your training";
/// with one it shows "Distance Target / 5km" (or the step / time /
/// calories equivalent) + setting icon.
class StartSessionModal extends StatelessWidget {
  const StartSessionModal({
    super.key,
    required this.type,
    required this.target,
    required this.targetValue,
    required this.onChooseTarget,
    required this.onEditTarget,
    required this.onStart,
  });

  final TrainingType type;
  final TrainingTarget target;
  final double? targetValue;
  final VoidCallback onChooseTarget;
  final VoidCallback onEditTarget;
  final VoidCallback onStart;

  static const playKey = ValueKey('training-play');
  static const pillKey = ValueKey('training-target-pill');

  @override
  Widget build(BuildContext context) {
    final value = targetValue;
    return TrainingModal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s3.h,
        children: [
          SessionHeader(type: type),
          Row(
            spacing: AppSpacing.s2.w,
            children: [
              Expanded(
                child: GestureDetector(
                  key: pillKey,
                  onTap: onChooseTarget,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 56.w,
                    // figma: padding 8/16, gap 10, space between.
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w),
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      spacing: 10.w,
                      children: [
                        Expanded(
                          child: value == null
                              ? Text(
                                  LocaleKeys.training_choose_tracking.tr(
                                    context: context,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textStat,
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: AppSpacing.s1.h,
                                  children: [
                                    Text(
                                      target.labelKey.tr(context: context),
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    Text(
                                      target.valueText(context, value),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textStat,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: AppSpacing.s2.w,
                          children: [
                            if (value != null)
                              GestureDetector(
                                onTap: onEditTarget,
                                behavior: HitTestBehavior.opaque,
                                child: SvgPicture.asset(
                                  'assets/icons/setting_slider.svg',
                                  width: 24.w,
                                  height: 24.w,
                                ),
                              ),
                            SvgPicture.asset(
                              'assets/icons/arrow_circle_down.svg',
                              width: 24.w,
                              height: 24.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SessionRoundButton(
                key: playKey,
                icon: 'assets/icons/play.svg',
                onPressed: onStart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
