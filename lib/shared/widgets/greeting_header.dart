import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../config/routing/route_names.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import '../../generated/locale_keys.g.dart';
import 'app_avatar.dart';

/// Avatar 48 · gap 16 · greeting (`headingMedium`) + [trailing]
/// (figma: Home 683:53154, notification panel 683:54696, Activity 683:53210,
/// Setting panel 683:54836).
///
/// Tapping the avatar opens the Setting panel ([RouteNames.kSettingsPage]).
/// Inside a popup (notification panel) the popup is closed first.
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.name,
    required this.avatar,
    required this.trailing,
    this.opensSettings = true,
  });

  /// Key of the tappable avatar (tests).
  static const avatarKey = ValueKey('greeting_header_avatar');

  final String name;
  final String avatar;
  final Widget trailing;

  /// False on the Setting panel itself.
  final bool opensSettings;

  static void _openSettings(BuildContext context) {
    final router = GoRouter.of(context);
    if (ModalRoute.of(context) is PopupRoute) {
      Navigator.of(context).pop();
    }
    router.push(RouteNames.kSettingsPage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          key: avatarKey,
          onTap: opensSettings ? () => _openSettings(context) : null,
          behavior: HitTestBehavior.opaque,
          child: AppAvatar(image: avatar),
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
