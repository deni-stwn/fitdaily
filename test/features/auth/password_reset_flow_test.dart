import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_template/config/routing/route_names.dart';
import 'package:flutter_clean_architecture_template/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter_clean_architecture_template/features/auth/presentation/pages/new_password_page.dart';
import 'package:flutter_clean_architecture_template/features/auth/presentation/pages/reset_success_page.dart';
import 'package:flutter_clean_architecture_template/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter_clean_architecture_template/features/auth/presentation/pages/verification_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../visual/render_screen.dart';

void main() {
  setUpAll(setUpVisual);

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  testWidgets('Sign In → Forgot → Verify → New → Success → Sign In', (
    tester,
  ) async {
    await pumpAppAt(tester, RouteNames.kSignInPage);

    await tapText(tester, 'Forgot Password');
    expect(find.byType(ForgotPasswordPage), findsOneWidget);

    await tapText(tester, 'Send Reset Link');
    expect(find.byType(VerificationPage), findsOneWidget);

    await tester.enterText(find.byType(TextField), '12345');
    await tester.pump();
    expect(find.text('5'), findsOneWidget); // last OTP box filled

    await tapText(tester, 'Confirm');
    expect(find.byType(NewPasswordPage), findsOneWidget);

    await tapText(tester, 'Reset Password');
    expect(find.byType(ResetSuccessPage), findsOneWidget);

    await tapText(tester, 'Back to login');
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('back arrow on Forgot Password returns to Sign In', (
    tester,
  ) async {
    await pumpAppAt(tester, RouteNames.kSignInPage);
    await tapText(tester, 'Forgot Password');
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    expect(find.byType(SignInPage), findsOneWidget);
  });
}
