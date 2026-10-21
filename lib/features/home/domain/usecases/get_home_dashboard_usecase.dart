import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/home_dashboard.dart';
import '../repositories/home_repository.dart';

class GetHomeDashboardUseCase implements UseCase<HomeDashboard, NoParam> {
  GetHomeDashboardUseCase(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, HomeDashboard>> call([NoParam? param]) =>
      repository.getDashboard();
}
