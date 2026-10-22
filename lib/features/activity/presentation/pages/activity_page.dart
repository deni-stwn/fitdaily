import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/activity_info_tile.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/greeting_header.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../home/presentation/manager/home/home_cubit.dart';
import '../../../home/presentation/widgets/notification_panel.dart';
import '../../domain/entities/activity_overview.dart';
import '../../domain/entities/training_index.dart';
import '../manager/activity/activity_cubit.dart';
import '../manager/activity/activity_state.dart';
import '../widgets/training_index_summary_card.dart';
import '../widgets/training_type_button.dart';

extension on TrainingType {
  /// History icon (Activity Info).
  String get historyIcon => switch (this) {
    TrainingType.running => 'assets/icons/history_run.svg',
    TrainingType.walking => 'assets/icons/history_walk.svg',
    TrainingType.cycling => 'assets/icons/training_bike.svg',
    TrainingType.gym => 'assets/icons/training_gym.svg',
  };
}

/// Figma: Activity (683:53210) — tab Activity of the navbar shell.
class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ActivityCubit>()..loadData()),
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

  /// Start Training buttons (left → right) and their training type.
  static const _trainings = <(String, TrainingType?)>[
    ('assets/icons/training_walk.svg', TrainingType.walking),
    ('assets/icons/training_run.svg', TrainingType.running),
    ('assets/icons/training_bike.svg', TrainingType.cycling),
    ('assets/icons/training_gym.svg', TrainingType.gym),
    ('assets/icons/training_more.svg', null),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        if (state is ActivityError) return Center(child: Text(state.message));
        if (state is! ActivityLoaded) return const LoadingWidget();
        final d = state.overview;
        final seeFullHistory = LocaleKeys.activity_see_full_history.tr(
          context: context,
        );

        return SingleChildScrollView(
          // Bottom space so the last card clears the navbar + fade.
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
              SizedBox(height: 14.h), // figma: 80 + 48 → 142
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2.w),
                child: Column(
                  spacing: AppSpacing.s2.h,
                  children: [
                    _card(
                      header: SectionHeader(
                        icon: 'assets/icons/section_start_training.svg',
                        title: LocaleKeys.activity_start_training.tr(
                          context: context,
                        ),
                        onAction: () =>
                            context.push(RouteNames.kStartTrainingPage),
                      ),
                      child: Row(
                        spacing: 6.w, // figma
                        children: [
                          for (final (icon, type) in _trainings)
                            Expanded(
                              child: TrainingTypeButton(
                                icon: icon,
                                // "…" has no screen yet.
                                onTap: type == null
                                    ? null
                                    : () => context.push(
                                        '${RouteNames.kStartTrainingPage}'
                                        '?type=${type.name}',
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    _card(
                      header: SectionHeader(
                        icon: 'assets/icons/section_history.svg',
                        title: LocaleKeys.activity_history.tr(context: context),
                        actionLabel: seeFullHistory,
                        onAction: () =>
                            context.push(RouteNames.kTrainingHistoryPage),
                      ),
                      child: Column(
                        spacing: AppSpacing.s1.h,
                        children: [
                          for (final h in d.history)
                            ActivityInfoTile(
                              icon: h.type.historyIcon,
                              title: h.title,
                              stats: [h.duration, h.calories, h.date],
                              value: h.distance,
                              unit: h.unit,
                              onTap: () =>
                                  context.push(RouteNames.kTrainingHistoryPage),
                            ),
                        ],
                      ),
                    ),
                    _card(
                      header: SectionHeader(
                        icon: 'assets/icons/section_training_index.svg',
                        title: LocaleKeys.activity_training_index.tr(
                          context: context,
                        ),
                        actionLabel: seeFullHistory,
                        onAction: () =>
                            context.push(RouteNames.kFitnessConditionPage),
                      ),
                      // Card content is not in the exported file —
                      // built from the design screenshot (see widget).
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.s1.w,
                        children: [
                          for (final t in d.trainingIndex)
                            Expanded(
                              child: TrainingIndexSummaryCard(
                                item: t,
                                onTap: () => context.push(
                                  t.kind == TrainingIndexKind.vo2Max
                                      ? RouteNames.kVo2MaxPage
                                      : RouteNames.kFitnessConditionPage,
                                ),
                              ),
                            ),
                        ],
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

  /// Figma *Card*: header · gap 16 · content.
  Widget _card({required Widget header, required Widget child}) {
    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3.h,
        children: [header, child],
      ),
    );
  }
}
