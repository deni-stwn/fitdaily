import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/domain/entities/training_index.dart';
import '../../features/activity/domain/entities/activity_overview.dart';
import '../../features/activity/presentation/pages/activity_page.dart';
import '../../features/activity/presentation/pages/start_training_page.dart';
import '../../features/activity/presentation/pages/training_history_page.dart';
import '../../features/activity/presentation/pages/training_index_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/new_password_page.dart';
import '../../features/auth/presentation/pages/reset_success_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/verification_page.dart';
import '../../features/devices/presentation/pages/device_setup_page.dart';
import '../../features/devices/presentation/pages/device_search_page.dart';
import '../../features/devices/presentation/pages/devices_faq_page.dart';
import '../../features/devices/presentation/pages/devices_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/settings/presentation/pages/app_settings_page.dart';
import '../../features/settings/presentation/pages/health_settings_page.dart';
import '../../features/settings/presentation/pages/notifications_settings_page.dart';
import '../../features/settings/presentation/pages/personal_info_page.dart';
import '../../features/settings/presentation/pages/privacy_data_page.dart';
import '../../features/settings/presentation/widgets/settings_panel.dart';
import '../../features/stats/domain/entities/metric_overview.dart';
import '../../features/stats/presentation/pages/heart_rate_overview_page.dart';
import '../../features/stats/presentation/pages/metric_overview_page.dart';
import '../../features/user_setup/presentation/manager/user_setup_cubit.dart';
import '../../features/user_setup/presentation/pages/goal_detail_pages.dart';
import '../../features/user_setup/presentation/pages/goal_form_page.dart';
import '../../features/user_setup/presentation/pages/goal_select_page.dart';
import '../../features/user_setup/presentation/pages/permission_page.dart';
import '../../core/di/injection_container.dart';
import '../../root.dart';
import '../../shared/widgets/placeholder_page.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteNames.kSplashPage,
  routes: [
    GoRoute(
      path: RouteNames.kSplashPage,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteNames.kOnboardingPage,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: RouteNames.kSignInPage,
      name: 'signIn',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: RouteNames.kPasswordResetPage,
      name: 'passwordReset',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: RouteNames.kPasswordResetVerifyPage,
      name: 'passwordResetVerify',
      builder: (context, state) => const VerificationPage(),
    ),
    GoRoute(
      path: RouteNames.kPasswordResetNewPage,
      name: 'passwordResetNew',
      builder: (context, state) => const NewPasswordPage(),
    ),
    GoRoute(
      path: RouteNames.kPasswordResetSuccessPage,
      name: 'passwordResetSuccess',
      builder: (context, state) => const ResetSuccessPage(),
    ),
    GoRoute(
      path: RouteNames.kSignUpPage,
      name: 'signUp',
      builder: (context, state) => const SignUpPage(),
    ),
    // Full screen above the navbar (pushed from the Home metric cards).
    GoRoute(
      path: RouteNames.kOverviewHistoryPage,
      name: 'overviewHistory',
      builder: (context, state) => const PlaceholderPage(title: 'History'),
    ),
    // Activity sub-screens (not sliced yet), full screen above the navbar.
    GoRoute(
      path: RouteNames.kStartTrainingPage,
      name: 'startTraining',
      // `?type=walking|running|cycling|gym` (default walking).
      builder: (context, state) => StartTrainingPage(
        type:
            TrainingType.values
                .asNameMap()[state.uri.queryParameters['type']] ??
            TrainingType.walking,
      ),
    ),
    GoRoute(
      path: RouteNames.kTrainingHistoryPage,
      name: 'trainingHistory',
      builder: (context, state) => const TrainingHistoryPage(),
    ),
    // Activity "Training Index" → Fitness Condition (same screen).
    GoRoute(
      path: RouteNames.kTrainingIndexPage,
      name: 'trainingIndex',
      builder: (context, state) =>
          const TrainingIndexPage(kind: TrainingIndexKind.fitnessCondition),
    ),
    GoRoute(
      path: RouteNames.kFitnessConditionPage,
      name: 'fitnessCondition',
      builder: (context, state) =>
          const TrainingIndexPage(kind: TrainingIndexKind.fitnessCondition),
    ),
    GoRoute(
      path: RouteNames.kVo2MaxPage,
      name: 'vo2Max',
      builder: (context, state) =>
          const TrainingIndexPage(kind: TrainingIndexKind.vo2Max),
    ),
    GoRoute(
      path: RouteNames.kHeartRateOverviewPage,
      name: 'heartRateOverview',
      builder: (context, state) => const HeartRateOverviewPage(),
    ),
    GoRoute(
      path: '${RouteNames.kOverviewPage}/:metric',
      name: 'overview',
      builder: (context, state) => MetricOverviewPage(
        metric:
            OverviewMetric.values.asNameMap()[state.pathParameters['metric']] ??
            OverviewMetric.steps,
      ),
    ),
    // Setting panel: transparent overlay above the current tab (opened from
    // the GreetingHeader avatar); sub pages are full screen above it.
    GoRoute(
      path: RouteNames.kSettingsPage,
      name: 'settings',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        opaque: false,
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: SettingsPanelPage.transition,
        child: const SettingsPanelPage(),
      ),
    ),
    GoRoute(
      path: RouteNames.kSettingsPersonalInfoPage,
      name: 'settingsPersonalInfo',
      builder: (context, state) => const PersonalInfoPage(),
    ),
    GoRoute(
      path: RouteNames.kSettingsHealthPage,
      name: 'settingsHealth',
      builder: (context, state) => const HealthSettingsPage(),
    ),
    GoRoute(
      path: RouteNames.kSettingsNotificationsPage,
      name: 'settingsNotifications',
      builder: (context, state) => const NotificationsSettingsPage(),
    ),
    GoRoute(
      path: RouteNames.kSettingsPrivacyPage,
      name: 'settingsPrivacy',
      builder: (context, state) => const PrivacyDataPage(),
    ),
    GoRoute(
      path: RouteNames.kSettingsAppPage,
      name: 'settingsApp',
      builder: (context, state) => const AppSettingsPage(),
    ),
    GoRoute(
      path: RouteNames.kDeviceSetupPage,
      name: 'deviceSetup',
      builder: (context, state) => const DeviceSetupPage(),
    ),
    // Devices sub-screens, full screen above the navbar.
    GoRoute(
      path: RouteNames.kDevicesSearchPage,
      name: 'devicesSearch',
      builder: (context, state) => const DeviceSearchPage(),
    ),
    GoRoute(
      path: RouteNames.kDevicesFaqPage,
      name: 'devicesFaq',
      builder: (context, state) => const DevicesFaqPage(),
    ),
    // User Setup flow shares one in-memory UserSetupCubit.
    ShellRoute(
      builder: (context, state, child) =>
          BlocProvider(create: (_) => sl<UserSetupCubit>(), child: child),
      routes: [
        GoRoute(
          path: RouteNames.kUserSetupPage,
          name: 'userSetup',
          builder: (context, state) => const PermissionPage(),
        ),
        GoRoute(
          path: RouteNames.kUserSetupGoalFormPage,
          name: 'userSetupGoalForm',
          builder: (context, state) => const GoalFormPage(),
        ),
        GoRoute(
          path: RouteNames.kUserSetupGoalsPage,
          name: 'userSetupGoals',
          builder: (context, state) => const GoalSelectPage(),
        ),
        GoRoute(
          path: RouteNames.kUserSetupStayActivePage,
          name: 'userSetupStayActive',
          builder: (context, state) => const StayActivePage(),
        ),
        GoRoute(
          path: RouteNames.kUserSetupIdealWeightPage,
          name: 'userSetupIdealWeight',
          builder: (context, state) => const IdealWeightPage(),
        ),
        GoRoute(
          path: RouteNames.kUserSetupSleepPage,
          name: 'userSetupSleep',
          builder: (context, state) => const SleepGoalPage(),
        ),
        GoRoute(
          path: RouteNames.kUserSetupStressPage,
          name: 'userSetupStress',
          builder: (context, state) => const StressPage(),
        ),
        GoRoute(
          path: RouteNames.kUserSetupConsistentPage,
          name: 'userSetupConsistent',
          builder: (context, state) => const ConsistentPage(),
        ),
      ],
    ),
    // Main app: 4 tabs (Figma navbar). Activity/Devices/Goals not sliced yet.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return RootPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.kRootPage,
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.kActivityPage,
              name: 'activity',
              builder: (context, state) => const ActivityPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.kDevicesPage,
              name: 'devices',
              builder: (context, state) => const DevicesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.kGoalsPage,
              name: 'goals',
              builder: (context, state) => const GoalsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
