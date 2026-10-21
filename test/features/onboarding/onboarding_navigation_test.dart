import 'package:flutter_clean_architecture_template/config/routing/route_names.dart';
import 'package:flutter_clean_architecture_template/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter_clean_architecture_template/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../visual/render_screen.dart';

void main() {
  setUpAll(setUpVisual);

  testWidgets('Continue opens Sign Up', (tester) async {
    await pumpAppAt(tester, RouteNames.kOnboardingPage);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpPage), findsOneWidget);
  });

  testWidgets('"Sign In" link opens Sign In', (tester) async {
    await pumpAppAt(tester, RouteNames.kOnboardingPage);
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('Sign In → "Sign Up" link opens Sign Up', (tester) async {
    await pumpAppAt(tester, RouteNames.kSignInPage);
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpPage), findsOneWidget);
  });
}
