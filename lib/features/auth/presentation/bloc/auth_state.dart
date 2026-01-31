/// Base class for authentication states
abstract class AuthState {}

/// Initial state when nothing has happened yet
class AuthInitial extends AuthState {}

/// State when login/logout is in progress
class AuthLoading extends AuthState {}

/// State when user is successfully authenticated
class AuthAuthenticated extends AuthState {}

/// State when an error occurs
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}