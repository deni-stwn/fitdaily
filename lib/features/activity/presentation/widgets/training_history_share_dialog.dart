import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_dialog.dart';
import '../../../../shared/widgets/app_icon_button.dart';

/// Shows the Share Report dialog (Figma 696:14296). UI only: the social
/// buttons do nothing, the copy icon copies the dummy link.
Future<void> showTrainingHistoryShareDialog(BuildContext context) {
  return showAppDialog<void>(
    context,
    builder: (_) => const TrainingHistoryShareDialog(),
  );
}

/// Card 312 wide, padding 12/20/24/20: close (32, right) · title (16/24,
/// centred) · gap 16 · "or copy link" · gap 16 · link field (`bgTertiary`,
/// radius 16, 48 high) · gap 16 · 4 round 44 buttons (gap 8, centred).
class TrainingHistoryShareDialog extends StatelessWidget {
  const TrainingHistoryShareDialog({super.key});

  static const _socials = [
    'assets/icons/share_facebook.svg',
    'assets/icons/share_instagram.svg',
    'assets/icons/share_whatsapp.svg',
    'assets/icons/more.svg',
  ];

  @override
  Widget build(BuildContext context) {
    final link = LocaleKeys.training_history_share_link.tr(context: context);
    return AppDialog(
      padding: 12,
      // figma: padding 12/20/24/20 → 12 all round + 8/12 extra.
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  'assets/icons/share_close.svg',
                  width: 32.w,
                  height: 32.w,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.s3.h,
              children: [
                Text(
                  LocaleKeys.training_history_share_title.tr(context: context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge,
                ),
                Text(
                  LocaleKeys.training_history_share_copy_link.tr(
                    context: context,
                  ),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall,
                ),
                Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w),
                  decoration: BoxDecoration(
                    color: AppColors.bgTertiary,
                    borderRadius: BorderRadius.circular(AppRadius.large.r),
                  ),
                  child: Row(
                    spacing: 10.w, // figma
                    children: [
                      Expanded(
                        child: Text(
                          link,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Clipboard.setData(ClipboardData(text: link)),
                        child: SvgPicture.asset(
                          'assets/icons/copy.svg',
                          width: 24.w,
                          height: 24.w,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: AppSpacing.s2.w,
                  children: [
                    for (final icon in _socials)
                      AppIconButton(
                        icon: icon,
                        size: 44,
                        iconSize: 20,
                        onPressed: () {},
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
