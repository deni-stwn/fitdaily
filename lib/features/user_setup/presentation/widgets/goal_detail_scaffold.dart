import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../generated/locale_keys.g.dart';
import '../manager/setup_goal.dart';
import '../manager/user_setup_cubit.dart';
import '../../../../shared/widgets/setup_scaffold.dart';
import 'setup_illustrations.dart';

/// Detail screen of a selected [goal] (11–15): "Next" goes to the next
/// selected goal, the last one shows "Finish" and opens Device Setup.
class GoalDetailScaffold extends StatelessWidget {
  const GoalDetailScaffold({
    super.key,
    required this.goal,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final SetupGoal goal;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UserSetupCubit>();
    final next = cubit.nextRoute(goal);

    return SetupScaffold(
      illustration: setupTargetIllustration,
      title: title,
      subtitle: subtitle,
      primaryLabel:
          (next == null
                  ? LocaleKeys.user_setup_finish
                  : LocaleKeys.user_setup_next)
              .tr(context: context),
      onPrimary: () => next == null
          ? context.go(RouteNames.kDeviceSetupPage)
          : context.push(next),
      children: children,
    );
  }
}
