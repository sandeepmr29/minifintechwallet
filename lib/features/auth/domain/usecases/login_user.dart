import '../entities/user.dart';
import '../repositories/auth_repository.dart';


class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  /// Executes the login with email and password
  /// Returns the User entity on success
  /// Throws exception/failure on error
  Future<User> call(String email, String password) async {
    // Additional domain-level validations can be added here
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }

    if (password.length < 4) {
      throw Exception('Password must be at least 4 characters');
    }

    // Call repository to perform login
    return await repository.login(email, password);
  }
}