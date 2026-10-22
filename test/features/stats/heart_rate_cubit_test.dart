import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/stats/domain/entities/heart_rate_overview.dart';
import 'package:flutter_clean_architecture_template/features/stats/domain/entities/metric_overview.dart';
import 'package:flutter_clean_architecture_template/features/stats/domain/repositories/stats_repository.dart';
import 'package:flutter_clean_architecture_template/features/stats/domain/usecases/get_heart_rate_overview_usecase.dart';
import 'package:flutter_clean_architecture_template/features/stats/presentation/manager/heart_rate/heart_rate_cubit.dart';
import 'package:flutter_clean_architecture_template/features/stats/presentation/manager/heart_rate/heart_rate_state.dart';
import 'package:flutter_test/flutter_test.dart';

const _overview = HeartRateOverview(
  current: 84,
  min: 47,
  max: 100,
  bars: [ChartBar(left: 0, top: 59.5, height: 6.51)],
  summary: [HeartRateStat(type: HeartRateStatType.range, value: '56-100')],
  zones: [HeartZone(type: HeartZoneType.light, minutes: 2, width: 19)],
);

class _Repo implements StatsRepository {
  _Repo(this.result);

  final Either<Failure, HeartRateOverview> result;

  @override
  Future<Either<Failure, HeartRateOverview>> getHeartRate() async => result;

  @override
  Future<Either<Failure, MetricOverview>> getOverview(OverviewMetric metric) =>
      throw UnimplementedError();
}

void main() {
  test('loads heart rate and switches period', () async {
    final cubit = HeartRateCubit(
      GetHeartRateOverviewUseCase(_Repo(const Right(_overview))),
    );
    await cubit.loadData();
    expect(cubit.state, const HeartRateLoaded(_overview));

    cubit.selectPeriod(OverviewPeriod.year);
    expect(
      cubit.state,
      const HeartRateLoaded(_overview, period: OverviewPeriod.year),
    );
    await cubit.close();
  });

  test('emits error on failure', () async {
    final cubit = HeartRateCubit(
      GetHeartRateOverviewUseCase(_Repo(const Left(UnexpectedFailure('x')))),
    );
    await cubit.loadData();
    expect(cubit.state, const HeartRateError('x'));
    await cubit.close();
  });
}
