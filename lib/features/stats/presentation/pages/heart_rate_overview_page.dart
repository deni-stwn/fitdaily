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
import '../../../../shared/widgets/charts/candle_chart.dart';
import '../../../../shared/widgets/charts/heart_zone_breakdown.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/overview_card_header.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/value_unit.dart';
import '../../domain/entities/heart_rate_overview.dart';
import '../../domain/entities/metric_overview.dart';
import '../manager/heart_rate/heart_rate_cubit.dart';
import '../manager/heart_rate/heart_rate_state.dart';
import '../widgets/summary_stat_grid.dart';

extension on HeartRateStatType {
  String get labelKey => switch (this) {
    HeartRateStatType.range => LocaleKeys.stats_range,
    HeartRateStatType.rest => LocaleKeys.stats_rest,
    HeartRateStatType.mid => LocaleKeys.stats_mid,
    HeartRateStatType.average => LocaleKeys.stats_average,
  };
}

/// Figma: Heartrate Monitoring — Day `683:54394` · Month `683:54343` ·
/// Year `683:54445` (same content, only the active tab differs).
class HeartRateOverviewPage extends StatelessWidget {
  const HeartRateOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HeartRateCubit>()..loadData(),
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
  const _Content();

  static const _periods = [
    LocaleKeys.stats_day,
    LocaleKeys.stats_month,
    LocaleKeys.stats_year,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeartRateCubit, HeartRateState>(
      builder: (context, state) {
        final cubit = context.read<HeartRateCubit>();
        return Column(
          children: [
            SizedBox(height: 20.h),
            AppTitleBar(
              variant: AppTitleBarVariant.standard,
              title: LocaleKeys.stats_heart_rate_title.tr(context: context),
              onBack: context.pop,
              actionIcon: 'assets/icons/more.svg',
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppSegmentedTab(
                labels: [for (final p in _periods) p.tr(context: context)],
                selectedIndex: state is HeartRateLoaded
                    ? state.period.index
                    : 0,
                onChanged: (i) => cubit.selectPeriod(OverviewPeriod.values[i]),
              ),
            ),
            SizedBox(height: AppSpacing.s2.h),
            Expanded(
              child: switch (state) {
                HeartRateError(:final message) => Center(child: Text(message)),
                HeartRateLoaded(:final overview) => SingleChildScrollView(
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
                      _ChartCard(overview: overview),
                      _SummaryCard(overview: overview),
                      GradientBorderCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.s3.h,
                          children: [
                            SectionHeader(
                              title: LocaleKeys.stats_heartrate_zone.tr(
                                context: context,
                              ),
                            ),
                            HeartZoneBreakdown(zones: overview.zones),
                          ],
                        ),
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

/// "Heart rate" card (figma: 8914): header · gap 16 · values + candle chart
/// (gap 8).
class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.overview});

  final HeartRateOverview overview;

  @override
  Widget build(BuildContext context) {
    final bpm = LocaleKeys.home_bpm.tr(context: context);
    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3.h,
        children: [
          OverviewCardHeader(
            title: LocaleKeys.stats_heart_rate.tr(context: context),
            subtitle: LocaleKeys.stats_heart_rate_subtitle.tr(context: context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s2.h,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueUnit(value: '${overview.current}', unit: bpm),
                  ValueUnit(
                    value: '${overview.min}-${overview.max}',
                    unit: bpm,
                  ),
                ],
              ),
              CandleChart(
                color: AppColors.iconDanger,
                bars: [
                  for (final b in overview.bars)
                    (left: b.left, top: b.top, height: b.height),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Day Summary" card (figma: 9017).
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.overview});

  final HeartRateOverview overview;

  @override
  Widget build(BuildContext context) {
    final bpm = LocaleKeys.home_bpm.tr(context: context);
    return GradientBorderCard(
      child: Column(
        spacing: AppSpacing.s3.h,
        children: [
          SectionHeader(
            title: LocaleKeys.stats_day_summary.tr(context: context),
          ),
          SummaryStatGrid(
            stats: [
              for (final s in overview.summary)
                (
                  value: s.value,
                  unit: bpm,
                  label: s.type.labelKey.tr(context: context),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
