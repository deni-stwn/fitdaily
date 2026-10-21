import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileLocalDataSource {
  Future<Either<Failure, ProfileEntity>> fetchProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<Either<Failure, ProfileEntity>> fetchProfile() async {
    // TODO: return dummy data
    throw UnimplementedError();
  }
}
