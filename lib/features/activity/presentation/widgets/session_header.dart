import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../domain/entities/activity_overview.dart';
import 'training_type_style.dart';

/// Header of the Start / Active Session modals: activity icon + name (gap
/// 8) ····· music · headphone · setting (24 each, gap 16, white 40%).
class SessionHeader extends StatelessWidget {
  const SessionHeader({super.key, required this.type});

  final TrainingType type;

  static const _icons = [
    'assets/icons/music.svg',
    'assets/icons/headphone.svg',
    'assets/icons/setting_hexagon.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.s2.w,
          children: [
            SvgPicture.asset(type.sessionIcon, width: 24.w, height: 24.w),
            Text(
              type.labelKey.tr(context: context),
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.s3.w,
          children: [
            for (final icon in _icons)
              SvgPicture.asset(icon, width: 24.w, height: 24.w),
          ],
        ),
      ],
    );
  }
}
