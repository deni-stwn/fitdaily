import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_segmented_tab.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/bottom_fade.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/charts/level_scale_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/training_index.dart';
import '../manager/training_index/training_index_cubit.dart';
import '../manager/training_index/training_index_state.dart';
import '../widgets/training_index_cards.dart';

/// Figma: Fitness Condition — Day `683:54496` · Month `683:54524`;
/// VO₂ Max — Day `683:54551` · Month `683:54573` (Day and Month have the
/// same content, only the active tab differs).
class TrainingIndexPage extends StatelessWidget {
  const TrainingIndexPage({
    super.key,
    required this.kind,
    this.initialPeriod = TrainingIndexPeriod.day,
  });

  final TrainingIndexKind kind;
  final TrainingIndexPeriod initialPeriod;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TrainingIndexCubit>()..loadData(kind, period: initialPeriod),
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
                SafeArea(bottom: false, child: _Content(kind: kind)),
                // figma: "Blurred Effect" only on Fitness Condition (the
                // VO₂ Max content ends above it).
                if (kind == TrainingIndexKind.fitnessCondition)
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BottomFade(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.kind});

  final TrainingIndexKind kind;

  static const _periods = [LocaleKeys.stats_day, LocaleKeys.stats_month];

  @override
  Widget build(BuildContext context) {
    final isFitness = kind == TrainingIndexKind.fitnessCondition;
    return BlocBuilder<TrainingIndexCubit, TrainingIndexState>(
      builder: (context, state) {
        final cubit = context.read<TrainingIndexCubit>();
        return Column(
          children: [
            SizedBox(height: 20.h),
            AppTitleBar(
              variant: AppTitleBarVariant.standard,
              title:
                  (isFitness
                          ? LocaleKeys.training_index_fitness_condition
                          : LocaleKeys.training_index_vo2_max)
                      .tr(context: context),
              onBack: context.pop,
              actionIcon: 'assets/icons/more.svg',
            ),
            SizedBox(height: 18.h), // figma: title bar 80+48 → tab 146
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppSegmentedTab(
                labels: [for (final p in _periods) p.tr(context: context)],
                selectedIndex: state is TrainingIndexLoaded
                    ? state.period.index
                    : 0,
                onChanged: (i) =>
                    cubit.selectPeriod(TrainingIndexPeriod.values[i]),
              ),
            ),
            SizedBox(height: AppSpacing.s2.h), // figma: tab 182 → card 190
            Expanded(
              child: switch (state) {
                TrainingIndexError(:final message) => Center(
                  child: Text(message),
                ),
                TrainingIndexLoaded(:final overview) => SingleChildScrollView(
                  // Bottom space so the last card clears the fade.
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.s2.w,
                    0,
                    AppSpacing.s2.w,
                    120.h,
                  ),
                  child: Column(
                    spacing: AppSpacing.s2.h,
                    children: [
                      TrainingIndexChartCard(overview: overview),
                      TrainingIndexLevelCard(
                        overview: overview,
                        icon: isFitness
                            ? 'assets/icons/section_interpretation.svg'
                            : 'assets/icons/section_weekly_summary.svg',
                        title:
                            (isFitness
                                    ? LocaleKeys.training_index_interpretation
                                    : LocaleKeys.training_index_weekly_summary)
                                .tr(context: context),
                        legendLayout: isFitness
                            ? LevelScaleLegendLayout.spread
                            : LevelScaleLegendLayout.wrap,
                      ),
                    ],
                  ),
                ),
                _ => const LoadingWidget(),
              },
            ),
          ],
        );
      },
    );
  }
}
