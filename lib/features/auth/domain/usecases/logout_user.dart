import '../repositories/auth_repository.dart';

/// Use case to log out the current user
class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  /// Executes logout
  /// Clears user session and token
  Future<void> call() async {
    await repository.logout();
  }
}