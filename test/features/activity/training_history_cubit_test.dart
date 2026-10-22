import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/entities/training_history.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/repositories/training_history_repository.dart';
import 'package:flutter_clean_architecture_template/features/activity/domain/usecases/get_training_history_usecase.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/manager/training_history/training_history_cubit.dart';
import 'package:flutter_clean_architecture_template/features/activity/presentation/manager/training_history/training_history_state.dart';
import 'package:flutter_test/flutter_test.dart';

HistoryRecord _record(String id) => HistoryRecord(
  id: id,
  activity: HistoryActivity.running,
  title: 'Running',
  duration: '40m 15s',
  calories: '3400 cal',
  date: '10 July',
  distance: '12',
  unit: 'km',
);

final _history = TrainingHistory({
  HistoryPeriod.day: [_record('d1'), _record('d2')],
  HistoryPeriod.month: [_record('m1')],
  HistoryPeriod.year: [_record('y1'), _record('d2')],
});

class _Repo implements TrainingHistoryRepository {
  _Repo(this.result);

  final Either<Failure, TrainingHistory> result;

  @override
  Future<Either<Failure, TrainingHistory>> getHistory() async => result;
}

TrainingHistoryCubit _cubit(Either<Failure, TrainingHistory> result) =>
    TrainingHistoryCubit(GetTrainingHistoryUseCase(_Repo(result)));

void main() {
  test('loads history on the Day tab', () async {
    final cubit = _cubit(Right(_history));
    await cubit.loadData();
    expect(cubit.state, TrainingHistoryLoaded(_history));
    expect((cubit.state as TrainingHistoryLoaded).records.length, 2);
    await cubit.close();
  });

  test('selectPeriod switches the records', () async {
    final cubit = _cubit(Right(_history));
    await cubit.loadData();
    cubit.selectPeriod(HistoryPeriod.month);
    final state = cubit.state as TrainingHistoryLoaded;
    expect(state.period, HistoryPeriod.month);
    expect(state.records.map((r) => r.id), ['m1']);
    await cubit.close();
  });

  test('deleteRecord removes the record from every tab', () async {
    final cubit = _cubit(Right(_history));
    await cubit.loadData();
    cubit.deleteRecord('d2');
    final state = cubit.state as TrainingHistoryLoaded;
    expect(state.records.map((r) => r.id), ['d1']);
    expect(state.history.of(HistoryPeriod.year).map((r) => r.id), ['y1']);
    await cubit.close();
  });

  test('emits error on failure', () async {
    final cubit = _cubit(const Left(UnexpectedFailure('x')));
    await cubit.loadData();
    expect(cubit.state, const TrainingHistoryError('x'));
    await cubit.close();
  });
}
