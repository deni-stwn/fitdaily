import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } on FormatException catch (e) {
    return Left(UnexpectedFailure(e.message));
  } catch (e) {
    return Left(UnexpectedFailure(e.toString()));
  }
}
