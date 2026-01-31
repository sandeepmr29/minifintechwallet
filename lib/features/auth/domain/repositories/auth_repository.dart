import '../entities/user.dart';

/// Interface for authentication repository
abstract class AuthRepository {
  /// Login user with email and password
  /// Throws exceptions on failure
  Future<User> login(String email, String password);

  /// Logout user
  Future<void> logout();

  /// Check if user is currently authenticated
  Future<bool> isLoggedIn();

  /// Get the currently logged-in user (if any)
  Future<User?> getCurrentUser();
}