import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimens.dart';
import '../../config/theme/app_text_styles.dart';
import '../../generated/locale_keys.g.dart';
import 'brand_effects.dart';

/// Tabs of the Figma *navbar* (`360:7737`), in order.
enum AppNavTab {
  home(LocaleKeys.navigation_home, 'nav_home'),
  activity(LocaleKeys.navigation_activity, 'nav_activity'),
  devices(LocaleKeys.navigation_devices, 'nav_devices'),
  goals(LocaleKeys.navigation_goals, 'nav_goals');

  const AppNavTab(this.labelKey, this._icon);

  final String labelKey;
  final String _icon;

  String get icon => 'assets/icons/$_icon.svg';
  String get activeIcon => 'assets/icons/${_icon}_active.svg';
}

/// Figma *navbar*: pill (`bg`, 1px `bgSecondary` border, padding 4, gap 6).
/// The active tab looks like Button Default (brand fill, Button Effect,
/// glow) with icon + label (hug, Home min 117); the others are a 56×48
/// icon. On tab change the brand pill slides to the new tab while the tabs
/// resize, the label slides in/out and the icons cross-fade.
class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _duration = Duration(milliseconds: 400);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final gap = 6.w;
    final widths = [
      for (final tab in AppNavTab.values)
        tab.index == currentIndex ? _activeWidth(context, tab) : _inactiveWidth,
    ];
    final pillLeft =
        widths.take(currentIndex).fold<double>(0, (sum, w) => sum + w) +
        gap * currentIndex;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border.all(color: AppColors.bgSecondary),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Stack(
        children: [
          // Sliding brand pill (same duration/curve as the tab widths, so
          // it stays aligned with the active tab during the animation).
          AnimatedPositioned(
            duration: _duration,
            curve: _curve,
            left: pillLeft,
            top: 0,
            width: widths[currentIndex],
            height: 48.h,
            child: const _Pill(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: gap,
            children: [
              for (final tab in AppNavTab.values)
                _NavItem(
                  tab: tab,
                  width: widths[tab.index],
                  active: tab.index == currentIndex,
                  onTap: () => onTap(tab.index),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Icon-only tab: 16 · icon 24 · 16.
  static double get _inactiveWidth => 56.w;

  /// 16 · icon 24 · 8 · label · 8 · 16 (Home at least 117).
  static double _activeWidth(BuildContext context, AppNavTab tab) {
    final painter = TextPainter(
      text: TextSpan(
        text: tab.labelKey.tr(context: context),
        style: AppTextStyles.bodySmallStrong,
      ),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();
    final hug = 72.w + painter.width;
    painter.dispose();
    return tab == AppNavTab.home && hug < 117.w ? 117.w : hug;
  }
}

/// Button Default look: `bgBrand`, Button Effect inner shadows, top glow.
class _Pill extends StatelessWidget {
  const _Pill();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.full);
    return ClipRRect(
      borderRadius: radius,
      child: CustomPaint(
        painter: InnerShadowPainter(
          color: AppColors.bgBrand,
          border: null,
          radius: radius,
          shadows: buttonEffect,
        ),
        child: LayoutBuilder(
          builder: (context, box) {
            // Glow = 34.78% of the width (same as AppButton).
            final width = box.maxWidth * 139.13 / 400;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -7.h,
                  left: (box.maxWidth - width) / 2,
                  child: BlurredEllipse(
                    width: width,
                    height: 14.h,
                    color: AppColors.textSecondary,
                    blur: 20,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.width,
    required this.active,
    required this.onTap,
  });

  final AppNavTab tab;
  final double width;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppNavBar._duration,
        curve: AppNavBar._curve,
        width: width,
        height: 48.h,
        alignment: Alignment.center,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: active ? 1 : 0),
          duration: AppNavBar._duration,
          curve: AppNavBar._curve,
          builder: (context, t, _) => ClipRect(
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Icon(tab: tab, t: t),
                  // Label slides out: [8][label][8] grows with t.
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: t,
                      child: Opacity(
                        opacity: t,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.s2.w,
                          ),
                          child: Text(
                            tab.labelKey.tr(context: context),
                            maxLines: 1,
                            softWrap: false,
                            style: AppTextStyles.bodySmallStrong,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Grey icon cross-fading into the white active icon.
class _Icon extends StatelessWidget {
  const _Icon({required this.tab, required this.t});

  final AppNavTab tab;
  final double t;

  @override
  Widget build(BuildContext context) {
    final size = 24.w;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          if (t < 1)
            Opacity(
              opacity: 1 - t,
              child: SvgPicture.asset(tab.icon, width: size, height: size),
            ),
          if (t > 0)
            Opacity(
              opacity: t,
              child: SvgPicture.asset(
                tab.activeIcon,
                width: size,
                height: size,
              ),
            ),
        ],
      ),
    );
  }
}
