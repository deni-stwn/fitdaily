import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'shared/widgets/app_nav_bar.dart';
import 'shared/widgets/bottom_fade.dart';

/// Main shell: tab content + Figma bottom fade + floating navbar
/// (navbar bottom 8 above the home indicator, centred).
class RootPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RootPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          const Positioned(left: 0, right: 0, bottom: 0, child: BottomFade()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.only(bottom: 8.h),
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Center(
                  child: AppNavBar(
                    currentIndex: navigationShell.currentIndex,
                    onTap: (index) => navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
