import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/stats/domain/entities/heart_rate_overview.dart';
import 'package:flutter_clean_architecture_template/features/stats/domain/entities/metric_overview.dart';
import 'package:flutter_clean_architecture_template/features/stats/domain/repositories/stats_repository.dart';
import 'package:flutter_clean_architecture_template/features/stats/domain/usecases/get_metric_overview_usecase.dart';
import 'package:flutter_clean_architecture_template/features/stats/presentation/manager/overview/overview_cubit.dart';
import 'package:flutter_clean_architecture_template/features/stats/presentation/manager/overview/overview_state.dart';
import 'package:flutter_test/flutter_test.dart';

OverviewPeriodData _period(int count, int selected) => OverviewPeriodData(
  title: 't',
  date: 'd',
  caption: 'c',
  selected: selected,
  bars: [
    for (var i = 0; i < count; i++)
      OverviewBar(label: '$i', height: 10, value: 'v$i', progress: i / count),
  ],
);

final _overview = MetricOverview(
  periods: {
    OverviewPeriod.day: _period(7, 6),
    OverviewPeriod.month: _period(4, 3),
    OverviewPeriod.year: _period(12, 11),
  },
  stats: const [],
  history: const [],
);

class _Repo implements StatsRepository {
  _Repo(this.result);

  final Either<Failure, MetricOverview> result;
  OverviewMetric? requested;

  @override
  Future<Either<Failure, MetricOverview>> getOverview(
    OverviewMetric metric,
  ) async {
    requested = metric;
    return result;
  }

  @override
  Future<Either<Failure, HeartRateOverview>> getHeartRate() =>
      throw UnimplementedError();
}

void main() {
  test('loads metric, switches period and bar', () async {
    final repo = _Repo(Right(_overview));
    final cubit = OverviewCubit(GetMetricOverviewUseCase(repo));
    await cubit.loadData(OverviewMetric.calories);
    expect(repo.requested, OverviewMetric.calories);

    var state = cubit.state as OverviewLoaded;
    expect(state.period, OverviewPeriod.day);
    expect(state.bar.value, 'v6');

    cubit.selectBar(2);
    expect((cubit.state as OverviewLoaded).bar.value, 'v2');

    cubit.selectPeriod(OverviewPeriod.year);
    state = cubit.state as OverviewLoaded;
    expect(state.period, OverviewPeriod.year);
    expect(state.selected, 11);
    await cubit.close();
  });

  test('emits error on failure', () async {
    final cubit = OverviewCubit(
      GetMetricOverviewUseCase(_Repo(const Left(UnexpectedFailure('x')))),
    );
    await cubit.loadData(OverviewMetric.steps);
    expect(cubit.state, const OverviewError('x'));
    await cubit.close();
  });
}
