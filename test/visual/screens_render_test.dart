import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_template/core/di/injection_container.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/entities/device_entity.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/repositories/devices_repository.dart';
import 'package:flutter_clean_architecture_template/features/devices/domain/usecases/get_devices_usecase.dart';
import 'package:flutter_clean_architecture_template/features/devices/presentation/manager/device/device_cubit.dart';
import 'package:flutter_clean_architecture_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_clean_architecture_template/config/routing/route_names.dart';
import 'package:flutter_clean_architecture_template/shared/widgets/greeting_header.dart';
import 'package:flutter_clean_architecture_template/shared/widgets/app_icon_button.dart';
import 'package:flutter_clean_architecture_template/shared/widgets/goal_item.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/widgets/active_session_modal.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/widgets/input_target_modal.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/widgets/start_session_modal.dart';
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

  testWidgets('34-home-bottom', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kRootPage,
      name: '34-home-bottom',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/avatar_brian.png',
      ],
      // Scroll Home to the end (Moving Time, Mood, Activity Overview, Sleep).
      interact: (tester) async {
        await tester.drag(
          find.descendant(
            of: find.byType(HomePage),
            matching: find.byType(SingleChildScrollView),
          ),
          const Offset(0, -3000),
        );
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
      },
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

  // 20 — Step / Calories Overview, Day · Month · Year.
  for (final metric in ['steps', 'calories']) {
    for (final (i, period) in ['Daily', 'Monthly', 'Yearly'].indexed) {
      testWidgets('20-$metric-$period', (tester) async {
        await renderScreen(
          tester,
          location: '${RouteNames.kOverviewPage}/$metric',
          name: '20-$metric-${period.toLowerCase()}',
          precache: ['assets/images/bg_pattern.png'],
          interact: i == 0
              ? null
              : (tester) async {
                  await tester.tap(find.text(i == 1 ? 'Month' : 'Year'));
                  await tester.pump(const Duration(milliseconds: 400));
                },
        );
      });
    }
  }

  // 21 — Heartrate Monitoring, Day · Month · Year.
  for (final (i, period) in ['daily', 'monthly', 'yearly'].indexed) {
    testWidgets('21-heartrate-$period', (tester) async {
      await renderScreen(
        tester,
        location: RouteNames.kHeartRateOverviewPage,
        name: '21-heartrate-$period',
        precache: ['assets/images/bg_pattern.png'],
        interact: i == 0
            ? null
            : (tester) async {
                await tester.tap(find.text(i == 1 ? 'Month' : 'Year'));
                await tester.pump(const Duration(milliseconds: 400));
              },
      );
    });
  }

  testWidgets('22-activity', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kActivityPage,
      name: '22-activity',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/avatar_brian.png',
      ],
    );
  });

  // 23 / 26 — Start Training flow (one page, states via taps).
  Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> openSetTarget(WidgetTester tester) =>
      tapAndWait(tester, find.byKey(StartSessionModal.pillKey));

  Future<void> openSetDistance(WidgetTester tester) async {
    await openSetTarget(tester);
    await tapAndWait(tester, find.text('By Distance'));
  }

  Future<void> setDistance(WidgetTester tester) async {
    await openSetDistance(tester);
    await tapAndWait(tester, find.byKey(InputTargetModal.doneKey));
  }

  Future<void> startWalking(WidgetTester tester) async {
    await setDistance(tester);
    await tapAndWait(tester, find.byKey(StartSessionModal.playKey));
  }

  for (final (name, interact)
      in <(String, Future<void> Function(WidgetTester)?)>[
        ('23-start-training', null),
        ('23-set-target', openSetTarget),
        ('23-set-distance', openSetDistance),
        ('26-distance-target', setDistance),
        ('23-walking-session', startWalking),
        (
          '23-target-reached',
          (tester) async {
            await startWalking(tester);
            await tapAndWait(tester, find.byKey(ActiveSessionModal.finishKey));
          },
        ),
      ]) {
    testWidgets(name, (tester) async {
      await renderScreen(
        tester,
        location: '${RouteNames.kStartTrainingPage}?type=walking',
        name: name,
        precache: [
          'assets/images/bg_pattern.png',
          'assets/images/training_map.png',
        ],
        interact: interact,
      );
    });
  }

  // 33 — Setting panel (tap the GreetingHeader avatar on Home) + sub pages.
  testWidgets('33-setting', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kRootPage,
      name: '33-setting',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/avatar_brian.png',
      ],
      interact: (tester) async {
        await tester.tap(find.byKey(GreetingHeader.avatarKey).first);
        for (var i = 0; i < 5; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          await tester.pump(const Duration(milliseconds: 100));
        }
      },
    );
  });

  for (final (name, location) in [
    ('33-personal-info', RouteNames.kSettingsPersonalInfoPage),
    ('33-health-settings', RouteNames.kSettingsHealthPage),
    ('33-privacy-data', RouteNames.kSettingsPrivacyPage),
    ('33-app-settings', RouteNames.kSettingsAppPage),
    ('33-notifications-settings', RouteNames.kSettingsNotificationsPage),
  ]) {
    testWidgets(name, (tester) async {
      await renderScreen(
        tester,
        location: location,
        name: name,
        precache: [
          'assets/images/bg_pattern.png',
          'assets/images/avatar_brian.png',
        ],
      );
    });
  }

  // 32 — Goals tab, Create Goals sheet, Commit step.
  Future<void> openCreateGoal(WidgetTester tester) async {
    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is AppIconButton && w.icon == 'assets/icons/add_circle.svg',
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  for (final (name, interact)
      in <(String, Future<void> Function(WidgetTester)?)>[
        ('32-goals', null),
        ('32-goals-create', openCreateGoal),
        (
          '32-goals-commit',
          (tester) async {
            await openCreateGoal(tester);
            // Steps starts selected → tapping it again continues to Commit.
            await tester.tap(find.widgetWithText(GoalItem, 'Steps'));
            await tester.pump(const Duration(milliseconds: 300));
          },
        ),
      ]) {
    testWidgets(name, (tester) async {
      await renderScreen(
        tester,
        location: RouteNames.kGoalsPage,
        name: name,
        precache: [
          'assets/images/bg_pattern.png',
          'assets/images/avatar_brian.png',
        ],
        interact: interact,
      );
    });
  }

  testWidgets('28-devices', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kDevicesPage,
      name: '28-devices',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/avatar_brian.png',
        'assets/images/device_watch_product.png',
        'assets/images/device_watch_thumb.png',
      ],
    );
  });

  // Detail sheet: tap the first "Heart rate" card.
  testWidgets('29-devices-detail', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kDevicesPage,
      name: '29-devices-detail',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/avatar_brian.png',
        'assets/images/device_watch_product.png',
        'assets/images/device_watch_thumb.png',
      ],
      interact: (tester) async {
        await tester.tap(find.text('Heart rate').first);
        for (var i = 0; i < 5; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          await tester.pump(const Duration(milliseconds: 100));
        }
      },
    );
  });

  testWidgets('30-devices-search', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kDevicesSearchPage,
      name: '30-devices-search',
      precache: [
        'assets/images/bg_pattern.png',
        'assets/images/device_radar.png',
        'assets/images/device_watch_thumb.png',
      ],
    );
  });

  testWidgets('31-devices-faq', (tester) async {
    await renderScreen(
      tester,
      location: RouteNames.kDevicesFaqPage,
      name: '31-devices-faq',
      precache: ['assets/images/bg_pattern.png'],
    );
  });

  // 24 / 25 — Fitness Condition and VO₂ Max (Day · Month).
  for (final (prefix, route) in [
    ('24-fitness-condition', RouteNames.kFitnessConditionPage),
    ('25-vo2max', RouteNames.kVo2MaxPage),
  ]) {
    for (final period in ['day', 'month']) {
      testWidgets('$prefix-$period', (tester) async {
        await renderScreen(
          tester,
          location: route,
          name: '$prefix-$period',
          precache: ['assets/images/bg_pattern.png'],
          interact: period == 'day'
              ? null
              : (tester) async {
                  await tester.tap(find.text('Month'));
                  await tester.pump(const Duration(milliseconds: 400));
                },
        );
      });
    }
  }

  // 27 — Training History (Daily · Monthly · Yearly) + option menu,
  // delete confirm and share dialog (opened from the title bar "more" on
  // the Month tab, as in Figma).
  for (final (i, period) in ['daily', 'monthly', 'yearly'].indexed) {
    testWidgets('27-training-history-$period', (tester) async {
      await renderScreen(
        tester,
        location: RouteNames.kTrainingHistoryPage,
        name: '27-training-history-$period',
        precache: ['assets/images/bg_pattern.png'],
        interact: i == 0
            ? null
            : (tester) async {
                await tester.tap(find.text(i == 1 ? 'Month' : 'Year'));
                await tester.pump(const Duration(milliseconds: 400));
              },
      );
    });
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> openHistoryOptions(WidgetTester tester) async {
    await tester.tap(find.text('Month'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(
      find
          .byWidgetPredicate(
            (w) => w is SvgPicture && '${w.bytesLoader}'.contains('more.svg'),
          )
          .first,
    );
    await settle(tester);
  }

  for (final (name, option) in [
    ('27-training-history-option', null),
    ('27-training-history-delete', 'Delete'),
    ('27-training-history-share', 'Share Report'),
  ]) {
    testWidgets(name, (tester) async {
      await renderScreen(
        tester,
        location: RouteNames.kTrainingHistoryPage,
        name: name,
        precache: ['assets/images/bg_pattern.png'],
        interact: (tester) async {
          await openHistoryOptions(tester);
          if (option != null) {
            await tester.tap(find.text(option));
            await settle(tester);
          }
        },
      );
    });
  }
}
