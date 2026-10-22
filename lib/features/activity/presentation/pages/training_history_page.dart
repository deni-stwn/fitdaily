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
import '../../../../shared/widgets/activity_info_tile.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_dialog.dart';
import '../../../../shared/widgets/app_segmented_tab.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/bottom_fade.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/training_history.dart';
import '../manager/training_history/training_history_cubit.dart';
import '../manager/training_history/training_history_state.dart';
import '../widgets/training_history_option_menu.dart';
import '../widgets/training_history_share_dialog.dart';

extension on HistoryActivity {
  /// Activity Info icon (Rowing uses the Running icon in the design).
  String get icon => switch (this) {
    HistoryActivity.running => 'assets/icons/history_run.svg',
    HistoryActivity.walking => 'assets/icons/history_walk.svg',
    HistoryActivity.cycling => 'assets/icons/history_cycling.svg',
    HistoryActivity.exercise => 'assets/icons/history_exercise.svg',
    HistoryActivity.rowing => 'assets/icons/history_run.svg',
  };
}

/// Figma: Training History — Daily `691:12274` · Monthly `691:12285` ·
/// Yearly `691:12296`; Option `696:12093` · Delete `696:12205` ·
/// Share `696:14296`.
///
/// The option menu opens from the title bar "more" (targets the first
/// record of the active tab) or from a long press on a record (targets
/// that record). Delete only changes the in-memory list.
class TrainingHistoryPage extends StatelessWidget {
  const TrainingHistoryPage({
    super.key,
    this.initialPeriod = HistoryPeriod.day,
  });

  final HistoryPeriod initialPeriod;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TrainingHistoryCubit>()..loadData(period: initialPeriod),
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

  Future<void> _openOptions(BuildContext context, HistoryRecord? record) async {
    final cubit = context.read<TrainingHistoryCubit>();
    final option = await showTrainingHistoryOptionMenu(context);
    if (!context.mounted || option == null) return;
    switch (option) {
      case TrainingHistoryOption.filterSort:
        break; // No Filter & Sort screen in the design.
      case TrainingHistoryOption.shareReport:
        await showTrainingHistoryShareDialog(context);
      case TrainingHistoryOption.delete:
        if (record == null) return;
        final confirmed = await showAppConfirmDialog(
          context,
          title: LocaleKeys.training_history_delete_title.tr(context: context),
          message: LocaleKeys.training_history_delete_message.tr(
            context: context,
          ),
          cancelLabel: LocaleKeys.training_history_cancel.tr(context: context),
          confirmLabel: LocaleKeys.training_history_delete.tr(context: context),
        );
        if (confirmed) cubit.deleteRecord(record.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingHistoryCubit, TrainingHistoryState>(
      builder: (context, state) {
        final cubit = context.read<TrainingHistoryCubit>();
        final records = state is TrainingHistoryLoaded
            ? state.records
            : const <HistoryRecord>[];
        return Column(
          children: [
            SizedBox(height: 20.h),
            AppTitleBar(
              variant: AppTitleBarVariant.standard,
              title: LocaleKeys.training_history_title.tr(context: context),
              onBack: context.pop,
              actionIcon: 'assets/icons/more.svg',
              onAction: () =>
                  _openOptions(context, records.isEmpty ? null : records.first),
            ),
            SizedBox(height: 18.h), // figma: title bar 80+48 → tab 146
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppSegmentedTab(
                labels: [for (final p in _periods) p.tr(context: context)],
                selectedIndex: state is TrainingHistoryLoaded
                    ? state.period.index
                    : 0,
                onChanged: (i) => cubit.selectPeriod(HistoryPeriod.values[i]),
              ),
            ),
            SizedBox(height: AppSpacing.s2.h), // figma: tab 182 → list 190
            Expanded(
              child: switch (state) {
                TrainingHistoryError(:final message) => Center(
                  child: Text(message),
                ),
                TrainingHistoryLoaded() => SingleChildScrollView(
                  // Bottom space so the last item clears the fade.
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.s2.w,
                    0,
                    AppSpacing.s2.w,
                    120.h,
                  ),
                  child: records.isEmpty
                      ? const SizedBox.shrink()
                      // figma: "Day/Month Container" padding 12, gap 4.
                      : GradientBorderCard(
                          padding: 12,
                          child: Column(
                            spacing: AppSpacing.s1.h,
                            children: [
                              for (final r in records)
                                ActivityInfoTile(
                                  icon: r.activity.icon,
                                  title: r.title,
                                  stats: [r.duration, r.calories, r.date],
                                  value: r.distance,
                                  unit: r.unit,
                                  onLongPress: () => _openOptions(context, r),
                                ),
                            ],
                          ),
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
