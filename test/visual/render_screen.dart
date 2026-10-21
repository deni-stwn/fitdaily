import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture_template/config/routing/app_router.dart';
import 'package:flutter_clean_architecture_template/config/theme/app_dimens.dart';
import 'package:flutter_clean_architecture_template/config/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Loads real fonts + localization once per test file.
Future<void> setUpVisual() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  for (final (family, file) in [
    ('InstrumentSans', 'assets/fonts/InstrumentSans-Variable.ttf'),
    ('InstrumentSerif', 'assets/fonts/InstrumentSerif-Regular.ttf'),
  ]) {
    await (FontLoader(family)..addFont(rootBundle.load(file))).load();
  }
}

/// Renders the app at [location] in the Figma frame (440×956 @2x, iPhone 15
/// Pro Max insets 60/34) and writes `build/visual/<name>.png` to compare
/// against `figma-code/<folder>/` screenshots.
Future<void> renderScreen(
  WidgetTester tester, {
  required String location,
  required String name,
  List<String> precache = const [],
}) async {
  tester.view.physicalSize = AppDesign.frameSize * 2;
  tester.view.devicePixelRatio = 2;
  tester.view.padding = const FakeViewPadding(top: 120, bottom: 68);
  addTearDown(tester.view.reset);

  final key = GlobalKey();
  final testRouter = GoRouter(
    initialLocation: location,
    routes: router.configuration.routes,
  );

  await tester.runAsync(() async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: Builder(
          builder: (context) => ScreenUtilInit(
            designSize: AppDesign.frameSize,
            builder: (context, _) => RepaintBoundary(
              key: key,
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.darkTheme,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                routerConfig: testRouter,
              ),
            ),
          ),
        ),
      ),
    );
    // Translations and SVGs load asynchronously.
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await tester.pump();
    }
    for (final asset in precache) {
      await precacheImage(AssetImage(asset), key.currentContext!);
    }
    await tester.pump();

    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('build/visual/$name.png')..createSync(recursive: true);
    file.writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}
