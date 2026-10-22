import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/gradient_border_card.dart';

/// Figma: Devices - Search Device (683:53294) — full screen above the
/// navbar, pushed from the "Add new devices" search button.
class DeviceSearchPage extends StatelessWidget {
  const DeviceSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    AppTitleBar(
                      variant: AppTitleBarVariant.standard,
                      title: LocaleKeys.devices_find_new_device.tr(
                        context: context,
                      ),
                      onBack: context.pop,
                    ),
                    SizedBox(height: 18.h), // figma: 128 → 146
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s2.w,
                      ),
                      // figma: diagonal border white 20% → 5% (approximated
                      // by the Card border).
                      child: GradientBorderCard(
                        child: SizedBox(
                          height: (651 - 40).h, // figma: 651 − padding
                          // figma: gap 86. The radar shrinks (keeps its
                          // square) when the screen is shorter than the
                          // design, so nothing overflows.
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.devices_waiting_connection.tr(
                                  context: context,
                                ),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headingMedium,
                              ),
                              SizedBox(height: 86.h),
                              const Flexible(child: _DeviceRadar()),
                              SizedBox(height: 86.h),
                              GestureDetector(
                                onTap: () =>
                                    context.push(RouteNames.kDevicesFaqPage),
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  LocaleKeys.devices_didnt_find.tr(
                                    context: context,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Device radar" 376×376 (radial/angular gradients exported as PNG) with
/// the found devices in white circles (figma: 40 · 80 · 45, padding 8 ·
/// 16 · 9).
class _DeviceRadar extends StatelessWidget {
  const _DeviceRadar();

  /// (left, top, circle size, padding) relative to the radar.
  static const _devices = <(double, double, double, double)>[
    (97, 68.5, 80, 16),
    (282, 224.5, 40, 8),
    (45, 300.5, 45, 9), // figma: (69, 444) in the card − radar (24, 143.5)
  ];

  static const _size = 376.0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: _size.w, maxHeight: _size.w),
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, box) => _radar(box.maxWidth / _size),
        ),
      ),
    );
  }

  /// [k] = actual radar size / design size.
  Widget _radar(double k) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: Image.asset('assets/images/device_radar.png')),
        for (final (left, top, circle, padding) in _devices)
          Positioned(
            left: left * k,
            top: top * k,
            child: Container(
              width: circle * k,
              height: circle * k,
              padding: EdgeInsets.all(padding * k),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/device_watch_thumb.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}
