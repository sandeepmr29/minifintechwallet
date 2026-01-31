/// Base exception for cache-related errors
class CacheException implements Exception {
  final String message;
  CacheException([this.message = "Cache error occurred"]);

  @override
  String toString() => "CacheException: $message";
}

/// Base exception for server/network-related errors
class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Server error occurred"]);

  @override
  String toString() => "ServerException: $message";
}

/// Exception for invalid input or business rule violations
class ValidationException implements Exception {
  final String message;
  ValidationException([this.message = "Validation error occurred"]);

  @override
  String toString() => "ValidationException: $message";
}

/// Exception for authentication failures
class AuthException implements Exception {
  final String message;
  AuthException([this.message = "Authentication failed"]);

  @override
  String toString() => "AuthException: $message";
}