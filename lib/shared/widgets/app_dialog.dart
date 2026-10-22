import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import 'app_button.dart';
import 'gradient_border_card.dart';

/// Shows [builder] centred over Figma *Blurred Effect · full*
/// (`691:12270`: `scrim` #262626 60% + background blur). The blur amount
/// is not in the export (tuned). Tap outside closes.
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, _, _) => Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const ColoredBox(color: AppColors.scrim),
            ),
          ),
        ),
        Center(child: builder(context)),
      ],
    ),
    transitionBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// Modal card (Figma *Card* 312 wide, radius 24, gradient border): Delete
/// confirm, Share.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.child,
    this.padding = 20,
    this.width = 312,
  });

  final Widget child;
  final double padding;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        width: width.w,
        child: GradientBorderCard(padding: padding, child: child),
      ),
    );
  }
}

/// Confirm dialog (Training History "Delete This Record?" 691:6138):
/// title (`bodyMedium`) · gap 16 · message (`bodySmall`, tertiary) · gap 16 ·
/// [Cancel (secondary small) | confirm (danger small)], gap 8.
/// Resolves to true when confirmed.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String cancelLabel,
  required String confirmLabel,
}) async {
  final result = await showAppDialog<bool>(
    context,
    builder: (context) => AppDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3.h,
        children: [
          Text(title, style: AppTextStyles.bodyMedium),
          Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          Row(
            spacing: AppSpacing.s2.w,
            children: [
              Expanded(
                child: AppButton(
                  label: cancelLabel,
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.small,
                  fullWidth: true,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              Expanded(
                child: AppButton(
                  label: confirmLabel,
                  variant: AppButtonVariant.danger,
                  size: AppButtonSize.small,
                  fullWidth: true,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  return result ?? false;
}
