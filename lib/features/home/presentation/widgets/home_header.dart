import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// Avatar 48 · gap 16 · greeting (`headingMedium`) + [trailing]
/// (figma: Home header 683:53154, notification panel 683:54696).
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.avatar,
    required this.trailing,
  });

  final String name;
  final String avatar;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            avatar,
            width: 48.w,
            height: 48.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: AppSpacing.s3.w),
        Expanded(
          child: Text(
            LocaleKeys.home_greeting.tr(context: context, args: [name]),
            style: AppTextStyles.headingMedium,
          ),
        ),
        trailing,
      ],
    );
  }
}
