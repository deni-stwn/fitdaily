import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../manager/setup_goal.dart';
import '../manager/user_setup_cubit.dart';
import '../manager/user_setup_state.dart';
import '../../../../shared/widgets/setup_scaffold.dart';
import '../widgets/setup_illustrations.dart';

/// Figma: User Setup - Goal, chip version (683:54142). Selected goal chips
/// are Button Default, others Button Secondary.
class GoalSelectPage extends StatelessWidget {
  const GoalSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSetupCubit, UserSetupState>(
      builder: (context, state) {
        final cubit = context.read<UserSetupCubit>();
        return SetupScaffold(
          illustration: setupTargetIllustration,
          title: LocaleKeys.user_setup_goals_title.tr(context: context),
          subtitle: LocaleKeys.user_setup_goals_subtitle.tr(context: context),
          primaryLabel: LocaleKeys.user_setup_save_goals.tr(context: context),
          onPrimary: () {
            final next = cubit.nextRoute();
            next == null
                ? context.go(RouteNames.kDeviceSetupPage)
                : context.push(next);
          },
          children: [
            Wrap(
              spacing: AppSpacing.s2.w,
              runSpacing: AppSpacing.s2.h,
              children: [
                for (final goal in SetupGoal.values)
                  AppButton(
                    label: goal.labelKey.tr(context: context),
                    icon: SvgPicture.asset(goal.icon),
                    variant: state.goals.contains(goal)
                        ? AppButtonVariant.primary
                        : AppButtonVariant.secondary,
                    onPressed: () => cubit.toggleGoal(goal),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
