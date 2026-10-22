import 'dart:math' as math;

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
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/blurred_overlay.dart';
import '../../../../shared/widgets/bottom_fade.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/activity_overview.dart';
import '../../domain/entities/training_session.dart';
import '../manager/training/training_cubit.dart';
import '../manager/training/training_state.dart';
import '../widgets/active_session_modal.dart';
import '../widgets/choose_target_sheet.dart';
import '../widgets/finish_session_modal.dart';
import '../widgets/input_target_modal.dart';
import '../widgets/start_session_modal.dart';
import '../widgets/training_map.dart';
import '../widgets/training_type_style.dart';

/// Figma: Activity training flow — Start Training `683:53476` · Set Target
/// `683:53521` · Set Distance `683:53556` · Distance Target `683:54595` ·
/// Walking Session `683:53588` · Target Reached `683:53639`. One page, the
/// step comes from [TrainingCubit] ([TrainingPhase]).
class StartTrainingPage extends StatelessWidget {
  const StartTrainingPage({super.key, this.type = TrainingType.walking});

  /// Training type from the Activity Start Training buttons (`?type=`).
  final TrainingType type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TrainingCubit>()..loadData(type),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          // The distance input moves above the keyboard itself.
          resizeToAvoidBottomInset: false,
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
                // figma: "Blurred effect" (bottom) 440×138 at y 818.
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomFade(),
                ),
                const _Content(),
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
    return BlocBuilder<TrainingCubit, TrainingState>(
      builder: (context, state) {
        final cubit = context.read<TrainingCubit>();
        final header = Column(
          children: [
            SizedBox(height: 20.h), // figma: title bar y 80 (status bar 60)
            AppTitleBar(
              variant: AppTitleBarVariant.standard,
              title: LocaleKeys.training_title.tr(context: context),
              onBack: context.pop,
              actionIcon: 'assets/icons/more.svg',
            ),
          ],
        );
        if (state is TrainingError) {
          return SafeArea(
            child: Column(
              children: [
                header,
                Expanded(child: Center(child: Text(state.message))),
              ],
            ),
          );
        }
        if (state is! TrainingLoaded) {
          return SafeArea(
            child: Column(
              children: [
                header,
                const Expanded(child: LoadingWidget()),
              ],
            ),
          );
        }

        final phase = state.phase;
        final value = state.targetValue;
        // Modal under the map: Start / Active Session. While the target
        // input or the finish modal covers it, it stays invisible but keeps
        // its space so the map does not resize.
        final startModal = StartSessionModal(
          type: state.type,
          target: state.target,
          targetValue: value,
          onChooseTarget: cubit.openTargetSheet,
          onEditTarget: cubit.editTarget,
          onStart: cubit.start,
        );
        final activeModal = ActiveSessionModal(
          type: state.type,
          target: state.target,
          currentValue: state.currentValue,
          targetValue: value ?? state.hint,
          paused: phase == TrainingPhase.paused,
          onPauseToggle: cubit.togglePause,
          onFinish: cubit.finish,
        );
        final Widget bottomModal = switch (phase) {
          TrainingPhase.idle ||
          TrainingPhase.choosingTarget ||
          TrainingPhase.targetSet => startModal,
          TrainingPhase.settingTarget => Visibility.maintain(
            visible: false,
            child: startModal,
          ),
          TrainingPhase.running || TrainingPhase.paused => activeModal,
          TrainingPhase.targetReached => Visibility.maintain(
            visible: false,
            child: activeModal,
          ),
        };
        // figma: container ends 50 above the frame bottom = home indicator
        // (34) + 16 → 16 above the system inset on every device.
        final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

        final keyboard = MediaQuery.viewInsetsOf(context).bottom;

        return Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  header,
                  SizedBox(height: 17.h), // figma: container y 145
                  // figma: Map 424×617 + gap 8 + Modal — the map takes the
                  // remaining height so the layout fits every screen.
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s2.w,
                      ),
                      child: TrainingMap(
                        setup: state.setup,
                        showRoute: state.hasSession,
                        progress: state.progress,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.s2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2.w),
                    child: bottomModal,
                  ),
                  SizedBox(height: bottomInset + AppSpacing.s3.h),
                ],
              ),
            ),
            if (phase == TrainingPhase.choosingTarget) ...[
              // figma: Blurred Effect full, #262626 60%.
              Positioned.fill(child: BlurredOverlay(onTap: cubit.dismissSheet)),
              _BottomSheet(
                bottom: 18, // figma: Card 8,500 424×438 → 18 to the bottom
                child: ChooseTargetSheet(
                  selected: state.target,
                  onSelect: cubit.selectTarget,
                ),
              ),
            ],
            if (phase == TrainingPhase.settingTarget) ...[
              // No blur in Set Distance: tap on the map closes the input.
              Positioned.fill(
                child: GestureDetector(
                  onTap: cubit.dismissSheet,
                  behavior: HitTestBehavior.translucent,
                ),
              ),
              _BottomSheet(
                // figma: Modal 8,718 424×201 → 37 to the bottom.
                bottom: 37,
                keyboard: keyboard,
                child: InputTargetModal(
                  // New instance per target so the field resets.
                  key: ValueKey(state.target),
                  target: state.target,
                  hint: state.hint,
                  initialValue: value,
                  onDone: cubit.setTargetValue,
                ),
              ),
            ],
            if (phase == TrainingPhase.targetReached) ...[
              // figma: Blurred Effect full, #262626 20%.
              const Positioned.fill(child: BlurredOverlay(opacity: 0.2)),
              _BottomSheet(
                bottom: 50, // figma: Modal 8,666 424×240 → 50 to the bottom
                child: FinishSessionModal(
                  summary: _summary(context, state),
                  distanceKm: state.coveredKm,
                  onClose: cubit.continueTraining,
                  onContinue: cubit.continueTraining,
                  onStop: context.pop,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Finish Session card from the dummy walk: type, simulated time,
/// calories (480 cal per km, design: 5 km → 2400 cal) and today's date.
TrainingRecord _summary(BuildContext context, TrainingLoaded state) {
  return TrainingRecord(
    type: state.type,
    title: state.type.labelKey.tr(context: context),
    duration: formatDuration(state.elapsed),
    calories: state.target == TrainingTarget.calories
        ? '${state.currentValue.floor()} cal'
        : '${(state.coveredKm * TrainingTargetX.kcalPerKm).round()} cal',
    date: DateFormat('d MMMM').format(DateTime.now()),
    distance: formatKm(state.coveredKm),
    unit: state.setup.summary.unit,
  );
}

/// Modal anchored to the bottom of the 956 frame (x 8, 424 wide); moves
/// above the keyboard when it is open.
class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    required this.bottom,
    required this.child,
    this.keyboard = 0,
  });

  final double bottom;
  final double keyboard;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.s2.w,
      right: AppSpacing.s2.w,
      bottom: math.max(bottom.h, keyboard + AppSpacing.s2.h),
      child: child,
    );
  }
}
