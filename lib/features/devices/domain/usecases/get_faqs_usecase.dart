import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/devices_overview.dart';
import '../repositories/devices_overview_repository.dart';

class GetFaqsUseCase implements UseCase<List<FaqItem>, NoParam> {
  final DevicesOverviewRepository repository;

  GetFaqsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FaqItem>>> call([NoParam? param]) {
    return repository.getFaqs();
  }
}
