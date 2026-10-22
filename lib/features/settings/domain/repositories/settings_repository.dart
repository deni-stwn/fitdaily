import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, UserSettings>> getSettings();

  Future<Either<Failure, UserSettings>> saveSettings(UserSettings settings);
}
