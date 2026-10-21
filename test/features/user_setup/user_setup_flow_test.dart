import 'package:flutter_clean_architecture_template/config/routing/route_names.dart';
import 'package:flutter_clean_architecture_template/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter_clean_architecture_template/features/user_setup/presentation/manager/setup_goal.dart';
import 'package:flutter_clean_architecture_template/features/user_setup/presentation/manager/user_setup_cubit.dart';
import 'package:flutter_clean_architecture_template/features/user_setup/presentation/pages/goal_detail_pages.dart';
import 'package:flutter_clean_architecture_template/features/user_setup/presentation/pages/goal_form_page.dart';
import 'package:flutter_clean_architecture_template/features/user_setup/presentation/pages/goal_select_page.dart';
import 'package:flutter_clean_architecture_template/features/user_setup/presentation/pages/permission_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../visual/render_screen.dart';

void main() {
  setUpAll(setUpVisual);

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  group('UserSetupCubit', () {
    test('default goals → Stay Active, Stress, Consistent', () {
      final cubit = UserSetupCubit();
      expect(cubit.nextRoute(), RouteNames.kUserSetupStayActivePage);
      expect(
        cubit.nextRoute(SetupGoal.stayActive),
        RouteNames.kUserSetupStressPage,
      );
      expect(cubit.isLast(SetupGoal.beConsistent), isTrue);
    });

    test('goals without a detail screen are skipped', () {
      final cubit = UserSetupCubit()
        ..toggleGoal(SetupGoal.stayActive)
        ..toggleGoal(SetupGoal.reduceStress)
        ..toggleGoal(SetupGoal.beConsistent)
        ..toggleGoal(SetupGoal.walkMore);
      expect(cubit.nextRoute(), isNull);
    });

    test('select-all toggle', () {
      final cubit = UserSetupCubit()..setAllPermissions(true);
      expect(cubit.state.permissions, SetupPermission.values.toSet());
      cubit.setAllPermissions(false);
      expect(cubit.state.permissions, isEmpty);
    });
  });

  testWidgets('Sign Up → Permission → Goals → selected goal screens', (
    tester,
  ) async {
    await pumpAppAt(tester, RouteNames.kSignUpPage);
    expect(find.byType(SignUpPage), findsOneWidget);

    await tapText(tester, 'Sign Up');
    expect(find.byType(PermissionPage), findsOneWidget);

    await tapText(tester, 'Allow Permission');
    expect(find.byType(GoalFormPage), findsOneWidget);

    await tapText(tester, 'Save Goals');
    expect(find.byType(GoalSelectPage), findsOneWidget);

    await tapText(tester, 'Save Goals');
    expect(find.byType(StayActivePage), findsOneWidget);

    await tapText(tester, 'Next');
    expect(find.byType(StressPage), findsOneWidget);

    await tapText(tester, 'Next');
    expect(find.byType(ConsistentPage), findsOneWidget);
    expect(find.text('Finish'), findsOneWidget);
  });
}
