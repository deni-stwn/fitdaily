import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/home/domain/entities/home_dashboard.dart';
import 'package:flutter_clean_architecture_template/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_clean_architecture_template/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:flutter_clean_architecture_template/features/home/presentation/manager/home/home_cubit.dart';
import 'package:flutter_clean_architecture_template/features/home/presentation/manager/home/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

const _dashboard = HomeDashboard(
  userName: 'Brian',
  avatar: '',
  quote: Quote(text: 'q', author: 'a'),
  steps: WeeklyMetric(value: 1, goal: 2, days: []),
  calories: WeeklyMetric(value: 1, goal: 2, days: []),
  heartRate: HeartRateSummary(current: 1, min: 0, max: 2, bars: [], zones: []),
  notifications: [
    HomeNotification(
      type: HomeNotificationType.steps,
      title: 't',
      message: 'm',
    ),
  ],
);

class _Repo implements HomeRepository {
  _Repo(this.result);

  final Either<Failure, HomeDashboard> result;

  @override
  Future<Either<Failure, HomeDashboard>> getDashboard() async => result;
}

void main() {
  test('loads, dismisses quote, clears notifications', () async {
    final cubit = HomeCubit(
      GetHomeDashboardUseCase(_Repo(const Right(_dashboard))),
    );
    await cubit.loadData();
    expect((cubit.state as HomeLoaded).showQuote, isTrue);

    cubit.dismissQuote();
    expect((cubit.state as HomeLoaded).showQuote, isFalse);

    cubit.clearNotifications();
    expect((cubit.state as HomeLoaded).dashboard.notifications, isEmpty);
    await cubit.close();
  });

  test('emits error on failure', () async {
    final cubit = HomeCubit(
      GetHomeDashboardUseCase(_Repo(const Left(UnexpectedFailure('x')))),
    );
    await cubit.loadData();
    expect(cubit.state, const HomeError('x'));
    await cubit.close();
  });
}
