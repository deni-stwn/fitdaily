import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';

/// Verification code boxes (figma: 683:53815): 5 × 72×96, gap 4, radius 16,
/// `bgTertiary`. One hidden text field drives all boxes (numeric,
/// auto-advance, paste/autofill friendly). The typed digit style is not in
/// the design (headingMedium, centred).
class OtpInput extends StatelessWidget {
  const OtpInput({super.key, required this.controller, this.length = 5});

  final TextEditingController controller;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => Row(
            spacing: AppSpacing.s1.w,
            children: [
              for (var i = 0; i < length; i++)
                Expanded(
                  child: Container(
                    height: 96.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.bgTertiary,
                      borderRadius: BorderRadius.circular(AppRadius.large.r),
                    ),
                    child: Text(
                      i < value.text.length ? value.text[i] : '',
                      style: AppTextStyles.headingMedium,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Invisible input on top of the boxes: receives taps and keystrokes.
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.oneTimeCode],
              maxLength: length,
              showCursor: false,
              enableInteractiveSelection: false,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
