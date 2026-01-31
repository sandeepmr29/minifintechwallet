/// Base Failure class
class Failure {
  final String message;
  Failure(this.message);
}

/// Failure for server or API errors
class ServerFailure extends Failure {
  ServerFailure([String message = "Server error occurred"]) : super(message);
}

/// Failure for cache or local database errors
class CacheFailure extends Failure {
  CacheFailure([String message = "Cache error occurred"]) : super(message);
}

/// Failure for authentication errors
class AuthFailure extends Failure {
  AuthFailure([String message = "Authentication failed"]) : super(message);
}

/// Failure for validation errors (business rules)
class ValidationFailure extends Failure {
  ValidationFailure([String message = "Validation failed"]) : super(message);
}