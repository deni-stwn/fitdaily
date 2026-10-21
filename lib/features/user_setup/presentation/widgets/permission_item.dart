import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../manager/setup_goal.dart';

/// Checkbox icon + label (figma: 683:53907). Selected = white box + white
/// label; unselected = dim box + `textTertiary` label.
class PermissionItem extends StatelessWidget {
  const PermissionItem({
    super.key,
    required this.permission,
    required this.selected,
    required this.onTap,
  });

  final SetupPermission permission;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        spacing: AppSpacing.s2.w,
        children: [
          SvgPicture.asset(
            selected
                ? 'assets/icons/checkbox_checked.svg'
                : 'assets/icons/checkbox_unchecked.svg',
            width: 24.w,
            height: 24.w,
          ),
          Text(
            permission.labelKey.tr(context: context),
            style: AppTextStyles.bodySmall.copyWith(
              color: selected ? AppColors.text : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
