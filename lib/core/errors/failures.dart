abstract class Failure {
  final String message;

  const Failure(this.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class CacheNotFoundFailure extends CacheFailure {
  const CacheNotFoundFailure([
    super.message = 'Requested data not found in cache.',
  ]);
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure(super.message, {this.fieldErrors});
}
