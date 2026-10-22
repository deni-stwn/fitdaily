import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/user_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase implements UseCase<UserSettings, NoParam> {
  GetSettingsUseCase(this.repository);

  final SettingsRepository repository;

  @override
  Future<Either<Failure, UserSettings>> call([NoParam? param]) =>
      repository.getSettings();
}
