import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_template/core/di/injection_container.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/entities/device_entity.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/repositories/devices_repository.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/usecases/get_devices_usecase.dart';
import 'package:flutter_clean_architecture_template/features/devices/presentation/manager/device/device_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_clean_architecture_template/config/routing/route_names.dart';
import 'package:flutter_test/flutter_test.dart';

import 'render_screen.dart';

class _NoDevices implements DevicesRepository {
  @override
  Future<Either<Failure, List<DeviceEntity>>> getDevices() async =>
      const Right([]);
}

// Run: fvm flutter test test/visual — output in build/visual/.
void main() {
  setUpAll(setUpVisual);

  testWidgets('01-onboarding / splash', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kSplashPage,
      name: '01-onboarding_splash',
    );
  });

  testWidgets('01-onboarding / onboarding', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kOnboardingPage,
      name: '01-onboarding',
      precache: ['assets/images/bg_pattern.png'],
    );
  });

  testWidgets('02-auth_sign_in', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kSignInPage,
      name: '02-auth_sign_in',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/sign_in_illustration.png',
      ],
    );
  });

  testWidgets('03-sign_up', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kSignUpPage,
      name: '03-sign_up',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/sign_in_illustration.png',
      ],
    );
  });

  // Focused + filled fields (no extra inner box, text vertically centred).
  testWidgets('03-sign_up / typing', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kSignUpPage,
      name: '03-sign_up_typing',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/sign_in_illustration.png',
      ],
      interact: (tester) async {
        final fields = find.byType(TextField);
        await tester.enterText(fields.at(1), 'kkbkbjbbj');
        await tester.enterText(fields.at(2), 'secret');
        await tester.tap(fields.at(0));
        await tester.enterText(fields.at(0), 'oh');
      },
    );
  });

  // macOS window (other size, no insets, desktop platform) to catch drift.
  testWidgets(
    '03-sign_up / macos window',
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
    (tester) async {
      await renderScreen(
        tester,
        location: RouteNames.kSignUpPage,
        name: '03-sign_up_macos',
        size: const Size(388, 791),
        padding: FakeViewPadding.zero,
        precache: [
          'assets/images/bg_pattern.png',
          'assets/images/sign_in_illustration.png',
        ],
        interact: (tester) => tester.tap(find.byType(TextField).at(1)),
      );
    },
  );

  testWidgets('04-password_reset', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kPasswordResetPage,
      name: '04-password_reset',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/lock_question.png',
      ],
    );
  });

  testWidgets('05-password-reset-verif', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kPasswordResetVerifyPage,
      name: '05-password-reset-verif',
      precache: ['assets/images/bg_pattern.png', 'assets/images/lock_code.png'],
    );
  });

  testWidgets('06-password-reset-create-pw', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kPasswordResetNewPage,
      name: '06-password-reset-create-pw',
      precache: ['assets/images/bg_pattern.png', 'assets/images/lock_open.png'],
    );
  });

  testWidgets('07-password-reset-success', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kPasswordResetSuccessPage,
      name: '07-password-reset-success',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/lock_check.png',
      ],
    );
  });

  testWidgets('08-user-setup-permission', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kUserSetupPage,
      name: '08-user-setup-permission',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/setup_permission.png',
      ],
    );
  });

  testWidgets('09-user-setup-goal', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kUserSetupGoalFormPage,
      name: '09-user-setup-goal',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/setup_target.png',
      ],
    );
  });

  testWidgets('10-user-setup-goal-2', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kUserSetupGoalsPage,
      name: '10-user-setup-goal-2',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/setup_target.png',
      ],
    );
  });

  testWidgets('11-user-setup-daily-routine', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kUserSetupStayActivePage,
      name: '11-user-setup-daily-routine',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/setup_target.png',
      ],
    );
  });

  testWidgets('12-user-setup-ideal-weight', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kUserSetupIdealWeightPage,
      name: '12-user-setup-ideal-weight',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/setup_target.png',
      ],
    );
  });

  testWidgets('13-user-setup-sleep-goal', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kUserSetupSleepPage,
      name: '13-user-setup-sleep-goal',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/setup_target.png',
      ],
    );
  });

  testWidgets('14-user-setup-streess-management', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kUserSetupStressPage,
      name: '14-user-setup-streess-management',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/setup_target.png',
      ],
    );
  });

  testWidgets('15-user-setup-commitment', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kUserSetupConsistentPage,
      name: '15-user-setup-commitment',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/setup_target.png',
      ],
    );
  });

  // 16 = scan finished with no device (Figma "Find Device").
  testWidgets('16-device-setup-find-device', (tester) async {
    sl.unregister<DeviceCubit>();
    sl.registerFactory(() => DeviceCubit(GetDevicesUseCase(_NoDevices())));
    addTearDown(() {
      sl.unregister<DeviceCubit>();
      sl.registerFactory(() => DeviceCubit(sl<GetDevicesUseCase>()));
    });
    await renderScreen(
      tester,
      location: RouteNames.kDeviceSetupPage,
      name: '16-device-setup-find-device',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/device_watch_illustration.png',
      ],
    );
  });

  // Scanning state (not in Figma): radar animation.
  testWidgets('16-device-setup-scanning', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kDeviceSetupPage,
      name: '16-device-setup-scanning',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/device_watch_illustration.png',
      ],
    );
  });

  testWidgets('17-device-setup-pairing-device', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kDeviceSetupPage,
      name: '17-device-setup-pairing-device',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/device_watch_illustration.png',
        'assets/images/device_samsung_watch.png',
      ],
      // Wait for the dummy scan to finish.
      interact: (tester) =>
          Future<void>.delayed(const Duration(milliseconds: 2500)),
    );
  });

  testWidgets('18-home', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kRootPage,
      name: '18-home',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/avatar_brian.png',
      ],
    );
  });

  testWidgets('19-notif-modal', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kRootPage,
      name: '19-notif-modal',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/avatar_brian.png',
      ],
      interact: (tester) async {
        await tester.tap(
          find.byWidgetPredicate(
            (w) => w is SvgPicture && '${w.bytesLoader}'.contains('bell'),
          ),
        );
        for (var i = 0; i < 5; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          await tester.pump(const Duration(milliseconds: 100));
        }
      },
    );
  });

  // Navbar active-tab widths (overflow regression).
  testWidgets('nav-activity', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kActivityPage,
      name: 'nav-activity',
    );
  });

  // Navbar active-tab widths (overflow regression).
  testWidgets('nav-devices', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kDevicesPage,
      name: 'nav-devices',
    );
  });

  // Navbar active-tab widths (overflow regression).
  testWidgets('nav-goals', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kGoalsPage,
      name: 'nav-goals',
    );
  });
}
