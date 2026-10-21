import 'package:flutter_clean_architecture_template/config/routing/route_names.dart';
import 'package:flutter_test/flutter_test.dart';

import 'render_screen.dart';

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
}
