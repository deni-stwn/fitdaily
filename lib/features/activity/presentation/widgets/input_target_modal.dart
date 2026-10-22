import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/training_session.dart';
import 'training_modal.dart';
import 'training_target_style.dart';

/// Figma *Modal* · Input Target (Set Distance 683:53556): 201 high, padding
/// 20, gap 16 · header [target icon · "Distance target"] · *Input* (no
/// title, placeholder "5", unit "KM") · *Button* "Done" (fill). Step, time
/// and calories use the same modal with their own icon, title and unit.
class InputTargetModal extends StatefulWidget {
  const InputTargetModal({
    super.key,
    required this.target,
    required this.hint,
    required this.onDone,
    this.initialValue,
  });

  final TrainingTarget target;

  /// Placeholder value (distance: "5").
  final double hint;
  final double? initialValue;

  /// Parsed value; null when empty / invalid.
  final ValueChanged<double?> onDone;

  static const doneKey = ValueKey('training-distance-done');

  @override
  State<InputTargetModal> createState() => _InputTargetModalState();
}

class _InputTargetModalState extends State<InputTargetModal> {
  late final _controller = TextEditingController(
    text: widget.initialValue == null
        ? ''
        : widget.target.format(widget.initialValue!),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _done() {
    FocusScope.of(context).unfocus();
    widget.onDone(double.tryParse(_controller.text.replaceAll(',', '.')));
  }

  @override
  Widget build(BuildContext context) {
    return TrainingModal(
      height: 201, // figma: fixed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s3.h,
        children: [
          Row(
            spacing: AppSpacing.s2.w,
            children: [
              SvgPicture.asset(widget.target.icon, width: 24.w, height: 24.w),
              Text(
                widget.target.inputTitleKey.tr(context: context),
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
          AppTextField(
            controller: _controller,
            hint: widget.target.format(widget.hint),
            suffixText: widget.target.unitKey.tr(context: context),
            keyboardType: TextInputType.numberWithOptions(
              decimal: widget.target.decimal,
            ),
            textInputAction: TextInputAction.done,
          ),
          AppButton(
            key: InputTargetModal.doneKey,
            label: LocaleKeys.training_done.tr(context: context),
            fullWidth: true,
            onPressed: _done,
          ),
        ],
      ),
    );
  }
}
