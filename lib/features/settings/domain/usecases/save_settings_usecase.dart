import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/user_settings.dart';
import '../repositories/settings_repository.dart';

class SaveSettingsUseCase implements UseCase<UserSettings, UserSettings> {
  SaveSettingsUseCase(this.repository);

  final SettingsRepository repository;

  @override
  Future<Either<Failure, UserSettings>> call([UserSettings? param]) =>
      repository.saveSettings(param!);
}
