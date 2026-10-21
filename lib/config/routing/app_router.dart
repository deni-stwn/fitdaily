import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
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
    // TODO: replace placeholders when 02-auth_sign_in / Sign Up are sliced.
    GoRoute(
      path: RouteNames.kSignInPage,
      name: 'signIn',
      builder: (context, state) => const PlaceholderPage(title: 'Sign In'),
    ),
    GoRoute(
      path: RouteNames.kSignUpPage,
      name: 'signUp',
      builder: (context, state) => const PlaceholderPage(title: 'Sign Up'),
    ),
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
              path: RouteNames.kCartPage,
              name: 'cart',
              builder: (context, state) => const CartPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.kProfilePage,
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
