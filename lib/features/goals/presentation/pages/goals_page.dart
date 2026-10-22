import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/greeting_header.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../home/presentation/manager/home/home_cubit.dart';
import '../../../home/presentation/widgets/notification_panel.dart';
import '../manager/goals/goals_cubit.dart';
import '../manager/goals/goals_state.dart';
import '../widgets/create_goal_sheet.dart';
import '../widgets/goal_summary_card.dart';
import '../widgets/goals_progress_bar.dart';
import '../widgets/tracked_goal_tile.dart';

/// Figma: Goals (683:53318) — tab Goals of the navbar shell.
class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<GoalsCubit>()..loadData()),
        // Notification panel (bell) reads the Home notifications.
        BlocProvider(create: (_) => sl<HomeCubit>()..loadData()),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: AppBackground(
            child: Stack(
              children: [
                // figma: "light effect" #1F076E 582×376 at (-71, -190).
                Positioned(
                  left: -71.w,
                  top: -190.h,
                  child: BlurredEllipse(
                    width: 582.w,
                    height: 376.h,
                    color: AppColors.violet1000,
                    blur: 200,
                  ),
                ),
                const SafeArea(bottom: false, child: _Content()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsCubit, GoalsState>(
      builder: (context, state) {
        if (state is GoalsError) return Center(child: Text(state.message));
        if (state is! GoalsLoaded) return const LoadingWidget();
        final d = state.overview;
        final weeklyGoals = LocaleKeys.goals_weekly_goals.tr(context: context);
        final complete = LocaleKeys.goals_complete.tr(context: context);

        return SingleChildScrollView(
          // Bottom space so the last row clears the navbar + fade.
          padding: EdgeInsets.only(top: 20.h, bottom: 140.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GreetingHeader(
                  name: d.userName,
                  avatar: d.avatar,
                  trailing: AppIconButton(
                    icon: 'assets/icons/bell.svg',
                    onPressed: () => showNotificationPanel(context),
                  ),
                ),
              ),
              SizedBox(height: 18.h), // figma: 80 + 48 → 146
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GoalsProgressBar(percent: d.progress, fill: d.progressFill),
                    SizedBox(height: AppSpacing.s3.h),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: AppSpacing.s1.w,
                        children: [
                          Expanded(
                            child: GoalSummaryCard(
                              title: weeklyGoals,
                              percent: d.weekly.percent,
                              bars: d.weekly.bars,
                              completeLabel: complete,
                              caption: weeklyGoals,
                              wideBars: true,
                            ),
                          ),
                          Expanded(
                            child: GoalSummaryCard(
                              title: LocaleKeys.goals_total_goals.tr(
                                context: context,
                              ),
                              percent: d.total.percent,
                              bars: d.total.bars,
                              completeLabel: complete,
                              // figma: caption also reads "Weekly Goals".
                              caption: weeklyGoals,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s2.h),
                    GradientBorderCard(
                      child: ConstrainedBox(
                        // figma: card fixed 448 high (padding 20 + 20).
                        constraints: BoxConstraints(minHeight: 406.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.s3.h,
                          children: [
                            SectionHeader(
                              icon: 'assets/icons/section_weekly_goals.svg',
                              title: weeklyGoals,
                              trailing: AppIconButton(
                                icon: 'assets/icons/add_circle.svg',
                                size: 40,
                                onPressed: () => showCreateGoalSheet(context),
                              ),
                            ),
                            Column(
                              spacing: AppSpacing.s1.h,
                              children: [
                                for (final (i, goal) in d.goals.indexed)
                                  TrackedGoalTile(
                                    goal: goal,
                                    onDelete: () => context
                                        .read<GoalsCubit>()
                                        .removeGoal(i),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
