import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_toggle.dart';
import '../../../../shared/widgets/card_scaffold.dart';
import '../manager/setup_goal.dart';
import '../manager/user_setup_cubit.dart';
import '../manager/user_setup_state.dart';
import '../widgets/permission_item.dart';
import '../../../../shared/widgets/setup_scaffold.dart';

/// Figma: User Setup - Permission (683:53907).
class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSetupCubit, UserSetupState>(
      builder: (context, state) {
        final cubit = context.read<UserSetupCubit>();
        return SetupScaffold(
          illustration: const CardIllustration.centered(
            'assets/images/setup_permission.png',
            width: 150.5,
            height: 165,
            top: 204,
          ),
          showSetupLater: false,
          title: LocaleKeys.user_setup_permission_title.tr(context: context),
          subtitle: LocaleKeys.user_setup_permission_subtitle.tr(
            context: context,
          ),
          primaryLabel: LocaleKeys.user_setup_allow_permission.tr(
            context: context,
          ),
          onPrimary: () => context.push(RouteNames.kUserSetupGoalFormPage),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s3.h,
              children: [
                for (final permission in SetupPermission.values)
                  PermissionItem(
                    permission: permission,
                    selected: state.permissions.contains(permission),
                    onTap: () => cubit.togglePermission(permission),
                  ),
              ],
            ),
            AppToggle(
              value: state.allPermissions,
              onChanged: cubit.setAllPermissions,
            ),
          ],
        );
      },
    );
  }
}
