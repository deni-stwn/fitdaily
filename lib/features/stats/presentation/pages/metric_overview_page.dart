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
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_segmented_tab.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/bottom_fade.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/charts/arc_gauge.dart';
import '../../../../shared/widgets/charts/summary_bar_chart.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/overview_card_header.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/entities/metric_overview.dart';
import '../manager/overview/overview_cubit.dart';
import '../manager/overview/overview_state.dart';
import '../widgets/history_tile.dart';
import '../widgets/stat_item.dart';

/// Look of each metric (Steps green, Calories yellow).
extension on OverviewMetric {
  String get titleKey => switch (this) {
    OverviewMetric.steps => LocaleKeys.stats_steps,
    OverviewMetric.calories => LocaleKeys.stats_calories,
  };

  /// Selected summary bar.
  Color get color => switch (this) {
    OverviewMetric.steps => AppColors.iconSuccess,
    OverviewMetric.calories => AppColors.iconWarning,
  };

  Color get arcColor => switch (this) {
    OverviewMetric.steps => AppColors.iconSuccess,
    OverviewMetric.calories => AppColors.gaugeWarning,
  };

  List<Color> get knobColors => switch (this) {
    OverviewMetric.steps => const [
      AppColors.iconSuccess,
      AppColors.gaugeSuccessDark,
    ],
    OverviewMetric.calories => const [
      AppColors.gaugeWarning,
      AppColors.gaugeWarningDark,
    ],
  };

  String get knobIcon => 'assets/icons/knob_$name.svg';
  String get icon => 'assets/icons/metric_$name.svg';

  /// Calories gauge sits 5 lower in a taller block (measured).
  double get gaugeOffset => this == OverviewMetric.calories ? 5 : 0;
  double get gaugeHeight => this == OverviewMetric.calories ? 221.5 : 212.5;
}

/// Figma: Step Overview (683:54172 / 54201 / 54230) and Calories Overview
/// (683:54259 / 54287 / 54315) — Day · Month · Year.
class MetricOverviewPage extends StatelessWidget {
  const MetricOverviewPage({super.key, required this.metric});

  final OverviewMetric metric;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OverviewCubit>()..loadData(metric),
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
                SafeArea(bottom: false, child: _Content(metric: metric)),
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
  const _Content({required this.metric});

  final OverviewMetric metric;

  static const _periods = [
    LocaleKeys.stats_day,
    LocaleKeys.stats_month,
    LocaleKeys.stats_year,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewCubit, OverviewState>(
      builder: (context, state) {
        final cubit = context.read<OverviewCubit>();
        return Column(
          children: [
            SizedBox(height: 20.h),
            AppTitleBar(
              variant: AppTitleBarVariant.standard,
              title: metric.titleKey.tr(context: context),
              onBack: context.pop,
              actionIcon: 'assets/icons/more.svg',
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppSegmentedTab(
                labels: [for (final p in _periods) p.tr(context: context)],
                selectedIndex: state is OverviewLoaded ? state.period.index : 0,
                onChanged: (i) => cubit.selectPeriod(OverviewPeriod.values[i]),
              ),
            ),
            SizedBox(height: AppSpacing.s2.h),
            Expanded(
              child: switch (state) {
                OverviewError(:final message) => Center(child: Text(message)),
                OverviewLoaded() => SingleChildScrollView(
                  // Bottom space so the last item clears the fade.
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.s2.w,
                    0,
                    AppSpacing.s2.w,
                    120.h,
                  ),
                  child: Column(
                    spacing: AppSpacing.s2.h,
                    children: [
                      _GaugeCard(metric: metric, state: state),
                      _SummaryCard(metric: metric, state: state),
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

class _GaugeCard extends StatelessWidget {
  const _GaugeCard({required this.metric, required this.state});

  final OverviewMetric metric;
  final OverviewLoaded state;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    final stats = state.overview.stats;
    return GradientBorderCard(
      child: Column(
        spacing: AppSpacing.s3.h,
        children: [
          OverviewCardHeader(title: data.title, subtitle: data.date),
          ArcGauge(
            progress: state.bar.progress,
            color: metric.arcColor,
            knobColors: metric.knobColors,
            knobIcon: metric.knobIcon,
            value: state.bar.value,
            caption: data.caption,
            height: metric.gaugeHeight,
            offsetY: metric.gaugeOffset,
          ),
          if (stats.isNotEmpty)
            Row(
              spacing: AppSpacing.s3.w,
              children: [
                for (final s in stats) Expanded(child: StatItem(stat: s)),
              ],
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.metric, required this.state});

  final OverviewMetric metric;
  final OverviewLoaded state;

  @override
  Widget build(BuildContext context) {
    final history = state.overview.history;
    final summary = LocaleKeys.stats_summary.tr(context: context);
    return GradientBorderCard(
      child: Column(
        spacing: AppSpacing.s3.h,
        children: [
          SectionHeader(title: summary),
          SummaryBarChart(
            bars: [
              for (final b in state.data.bars)
                (label: b.label, height: b.height),
            ],
            selectedIndex: state.selected,
            color: metric.color,
            onSelect: context.read<OverviewCubit>().selectBar,
          ),
          if (history.isNotEmpty) ...[
            SectionHeader(
              title: summary,
              actionLabel: LocaleKeys.stats_view_all.tr(context: context),
              onAction: () => context.push(RouteNames.kOverviewHistoryPage),
            ),
            // Gap between items not in the design (one item) → 8.
            Column(
              spacing: AppSpacing.s2.h,
              children: [
                for (final h in history)
                  HistoryTile(item: h, icon: metric.icon),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
