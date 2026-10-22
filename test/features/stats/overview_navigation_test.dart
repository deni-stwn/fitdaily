import 'package:flutter_clean_architecture_template/config/routing/route_names.dart';
import 'package:flutter_clean_architecture_template/features/stats/domain/entities/metric_overview.dart';
import 'package:flutter_clean_architecture_template/features/stats/presentation/pages/heart_rate_overview_page.dart';
import 'package:flutter_clean_architecture_template/features/stats/presentation/pages/metric_overview_page.dart';
import 'package:flutter_clean_architecture_template/shared/widgets/weekly_bar_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../visual/render_screen.dart';

void main() {
  setUpAll(setUpVisual);

  testWidgets('Home metric chevrons open their overview, back returns', (
    tester,
  ) async {
    await pumpAppAt(tester, RouteNames.kRootPage);

    // Dummy JSON loads asynchronously (loading spinner never settles).
    Future<void> settle() async {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      // First frame of a route transition is offstage.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    for (final (index, metric) in OverviewMetric.values.indexed) {
      await settle();
      final chevron = find.descendant(
        of: find.byType(WeeklyBarCard).at(index),
        matching: find.byWidgetPredicate(
          (w) =>
              w is SvgPicture && '${w.bytesLoader}'.contains('chevron_right'),
        ),
      );
      await tester.tap(chevron);
      await settle();

      final page = tester.widget<MetricOverviewPage>(
        find.byType(MetricOverviewPage),
      );
      expect(page.metric, metric);

      // Title bar back button.
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is SvgPicture && '${w.bytesLoader}'.contains('arrow_left'),
        ),
      );
      await settle();
      expect(find.byType(MetricOverviewPage), findsNothing);
    }
  });

  testWidgets('Home "Full Report" opens Heartrate, back returns', (
    tester,
  ) async {
    await pumpAppAt(tester, RouteNames.kRootPage);

    Future<void> settle() async {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    await settle();
    final fullReport = find.text('Full Report');
    await tester.ensureVisible(fullReport);
    await tester.pump();
    await tester.tap(fullReport);
    await settle();
    expect(find.byType(HeartRateOverviewPage), findsOneWidget);

    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is SvgPicture && '${w.bytesLoader}'.contains('arrow_left'),
      ),
    );
    await settle();
    expect(find.byType(HeartRateOverviewPage), findsNothing);
  });
}
