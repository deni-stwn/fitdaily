import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/new_password_page.dart';
import '../../features/auth/presentation/pages/reset_success_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/verification_page.dart';
import '../../features/devices/presentation/pages/device_setup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
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
    GoRoute(
      path: RouteNames.kDeviceSetupPage,
      name: 'deviceSetup',
      builder: (context, state) => const DeviceSetupPage(),
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
              builder: (context, state) =>
                  const PlaceholderPage(title: 'Activity'),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.kDevicesPage,
              name: 'devices',
              builder: (context, state) =>
                  const PlaceholderPage(title: 'Devices'),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.kGoalsPage,
              name: 'goals',
              builder: (context, state) =>
                  const PlaceholderPage(title: 'Goals'),
            ),
          ],
        ),
      ],
    ),
  ],
);
