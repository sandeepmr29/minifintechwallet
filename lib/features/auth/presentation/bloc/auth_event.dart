/// Base class for authentication events
abstract class AuthEvent {}

/// Triggered when user wants to log in
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

/// Triggered when user wants to log out
class LogoutEvent extends AuthEvent {}