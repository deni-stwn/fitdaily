import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../repositories/home_repository.dart';

/// "Clear All Notification": empties the notification list for the rest of
/// the app session (Home, Activity, Devices, Goals panels).
class ClearNotificationsUseCase implements UseCase<Unit, NoParam> {
  ClearNotificationsUseCase(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, Unit>> call([NoParam? param]) =>
      repository.clearNotifications();
}
