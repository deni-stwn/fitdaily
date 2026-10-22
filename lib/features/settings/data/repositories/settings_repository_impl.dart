import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this.localDataSource);

  final SettingsLocalDataSource localDataSource;

  @override
  Future<Either<Failure, UserSettings>> getSettings() =>
      safeCall(localDataSource.fetchSettings);

  @override
  Future<Either<Failure, UserSettings>> saveSettings(UserSettings settings) =>
      safeCall(() => localDataSource.saveSettings(settings));
}
