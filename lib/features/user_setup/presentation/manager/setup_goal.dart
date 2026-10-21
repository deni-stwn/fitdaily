import '../../../../config/routing/route_names.dart';
import '../../../../generated/locale_keys.g.dart';

/// Goals on "User Setup - Goal" (683:54142), in Figma order. [route] is the
/// goal's detail screen; goals without one are skipped in the flow.
enum SetupGoal {
  stayActive(
    'assets/icons/goal_stay_active.svg',
    LocaleKeys.user_setup_goal_stay_active,
    RouteNames.kUserSetupStayActivePage,
  ),
  loseWeight(
    'assets/icons/goal_lose_weight.svg',
    LocaleKeys.user_setup_goal_lose_weight,
    RouteNames.kUserSetupIdealWeightPage,
  ),
  betterSleep(
    'assets/icons/goal_better_sleep.svg',
    LocaleKeys.user_setup_goal_better_sleep,
    RouteNames.kUserSetupSleepPage,
  ),
  reduceStress(
    'assets/icons/goal_reduce_stress.svg',
    LocaleKeys.user_setup_goal_reduce_stress,
    RouteNames.kUserSetupStressPage,
  ),
  beConsistent(
    'assets/icons/goal_be_consistent.svg',
    LocaleKeys.user_setup_goal_be_consistent,
    RouteNames.kUserSetupConsistentPage,
  ),
  walkMore(
    'assets/icons/goal_walk_more.svg',
    LocaleKeys.user_setup_goal_walk_more,
  ),
  feelEnergetic(
    'assets/icons/goal_feel_energetic.svg',
    LocaleKeys.user_setup_goal_feel_energetic,
  ),
  improveFitness(
    'assets/icons/goal_improve_fitness.svg',
    LocaleKeys.user_setup_goal_improve_fitness,
  );

  const SetupGoal(this.icon, this.labelKey, [this.route]);

  final String icon;
  final String labelKey;
  final String? route;
}

/// Permission items on "User Setup - Permission" (683:53907).
enum SetupPermission {
  heartRate(LocaleKeys.user_setup_permission_heart_rate),
  activity(LocaleKeys.user_setup_permission_activity),
  sleep(LocaleKeys.user_setup_permission_sleep),
  notifications(LocaleKeys.user_setup_permission_notifications);

  const SetupPermission(this.labelKey);

  final String labelKey;
}
