import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_dropdown_field.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/goal_item.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../domain/entities/goals_overview.dart';
import '../manager/goals/goals_cubit.dart';
import '../manager/goals/goals_state.dart';
import 'goal_type_ui.dart';

/// Opens "Goals - Create Goals" (683:53393) over the blurred Goals tab
/// (Figma *Blurred Effect · full*: `sheetScrim` + background blur 4).
/// Choosing a goal → "Commit" step (683:54754); Done adds it to
/// [GoalsCubit].
Future<void> showCreateGoalSheet(BuildContext context) {
  final cubit = context.read<GoalsCubit>();
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'create-goal',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, _, _) =>
        BlocProvider.value(value: cubit, child: const _CreateGoalOverlay()),
    transitionBuilder: (_, animation, _, child) => FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    ),
  );
}

class _CreateGoalOverlay extends StatelessWidget {
  const _CreateGoalOverlay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: BackdropFilter(
              // figma: background blur 4 (≈ 2 × sigma).
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: const ColoredBox(color: AppColors.sheetScrim),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: const CreateGoalSheet(),
          ),
        ),
      ],
    );
  }
}

/// Sheet card (424 wide, `bg`, radius 24, padding 20, gap 16): header
/// (32 target icon · title/subtitle · close) + step content. The first goal
/// starts selected (as in Figma); tapping another goal selects it, tapping
/// the selected goal continues to the Commit step.
class CreateGoalSheet extends StatefulWidget {
  const CreateGoalSheet({super.key});

  @override
  State<CreateGoalSheet> createState() => _CreateGoalSheetState();
}

class _CreateGoalSheetState extends State<CreateGoalSheet> {
  GoalType _goal = GoalType.values.first;
  bool _committing = false;
  String? _target;
  final _commitment = TextEditingController();

  @override
  void dispose() {
    _commitment.dispose();
    super.dispose();
  }

  void _onGoalTap(GoalType goal) {
    setState(() {
      if (goal == _goal) {
        _committing = true;
      } else {
        _goal = goal;
        _target = null;
      }
    });
  }

  void _onDone() {
    context.read<GoalsCubit>().addGoal(
      TrackedGoal(
        name: _goal.titleKey.tr(context: context),
        tracking: _target ?? '-',
        status: GoalStatus.incomplete,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // figma: card bottom at 930 (Create) / 917 (Commit) of 956.
    final bottom = _committing ? 39.0 : 26.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s2.w,
        0,
        AppSpacing.s2.w,
        bottom.h,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: GradientBorderCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s3.h,
            children: [
              _Header(
                title: _committing
                    ? LocaleKeys.goals_create_goal.tr(context: context)
                    : _goal.titleKey.tr(context: context),
              ),
              if (_committing) _commitStep(context) else _chooseStep(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chooseStep(BuildContext context) {
    return Column(
      spacing: AppSpacing.s1.h,
      children: [
        for (final goal in GoalType.values)
          GoalItem(
            icon: goal.icon,
            title: goal.titleKey.tr(context: context),
            description: goal.descriptionKey.tr(context: context),
            selected: goal == _goal,
            onTap: () => _onGoalTap(goal),
          ),
      ],
    );
  }

  Widget _commitStep(BuildContext context) {
    final state = context.watch<GoalsCubit>().state;
    final options = state is GoalsLoaded
        ? state.overview.targets[_goal] ?? const <String>[]
        : const <String>[];
    final hint = LocaleKeys.goals_target_hint.tr(context: context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s3.h,
      children: [
        AppDropdownField<String?>(
          label: LocaleKeys.goals_target.tr(context: context),
          value: _target,
          options: options,
          optionLabel: (o) => o ?? hint,
          onChanged: (v) => setState(() => _target = v),
        ),
        AppTextField(
          label: LocaleKeys.goals_commitment.tr(context: context),
          hint: LocaleKeys.goals_commitment_hint.tr(context: context),
          controller: _commitment,
          variant: AppTextFieldVariant.textarea,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
        ),
        AppButton(
          label: LocaleKeys.goals_done.tr(context: context),
          fullWidth: true,
          onPressed: _onDone,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.s2.w,
      children: [
        SvgPicture.asset(
          'assets/icons/goal_target.svg',
          width: 32.w,
          height: 32.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s1.h,
            children: [
              Text(title, style: AppTextStyles.bodyMedium),
              Text(
                LocaleKeys.goals_create_subtitle.tr(context: context),
                style: AppTextStyles.bodySmallStrong.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        // figma: Button with a broken label ("Button") — rendered as the
        // close icon button (48, transparent).
        AppIconButton(
          icon: 'assets/icons/close.svg',
          filled: false,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
