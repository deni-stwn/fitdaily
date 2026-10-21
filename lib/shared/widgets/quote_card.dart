import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import 'brand_effects.dart';

/// Figma *Quotes* (`624:6398`): `bgBrand` card, radius 24, padding 20,
/// Button Effect inner shadows + top light, quote (20/w450/h1.2) + author,
/// close X, big IcoMoon "quotes-left" decoration (154 at 244/26, clipped).
class QuoteCard extends StatelessWidget {
  const QuoteCard({
    super.key,
    required this.text,
    required this.author,
    required this.onClose,
  });

  final String text;
  final String author;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.xLarge.r);
    return ClipRRect(
      borderRadius: radius,
      child: CustomPaint(
        painter: InnerShadowPainter(
          color: AppColors.bgBrand,
          border: null,
          radius: radius,
          shadows: buttonEffect,
        ),
        child: Stack(
          children: [
            // figma: light spot 164×48 at (130, -40) — blur tuned visually.
            Positioned(
              left: 130.w,
              top: -40.h,
              child: BlurredEllipse(
                width: 164.w,
                height: 48.h,
                color: const Color(0xFFD9D9D9),
                blur: 60,
              ),
            ),
            Positioned(
              left: 244.w,
              top: 26.h,
              child: SvgPicture.asset(
                'assets/icons/quote_mark.svg',
                width: 154.w,
                height: 154.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.s3.h,
                      children: [
                        SizedBox(
                          width: 250.w,
                          child: Text(
                            text,
                            // figma: 20 / w450 / h1.2 (no text style)
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontSize: 20.sp,
                              height: 1.2,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Text(author, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(
                      'assets/icons/close.svg',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
