import '../../../../core/security/token_manager.dart';
import '../../domain/entities/user.dart';


/// Handles local storage of authentication data
class AuthLocalDataSource {
  final TokenManager tokenManager;

  AuthLocalDataSource({required this.tokenManager});

  /// Save user token locally after login
  Future<void> saveToken(String token) async {
    await tokenManager.saveToken(token);
  }

  /// Get stored token
  Future<String?> getToken() async {
    return await tokenManager.getToken();
  }

  /// Delete token (logout)
  Future<void> deleteToken() async {
    await tokenManager.deleteToken();
  }

  /// Optional: get current user from token (mocked)
  Future<User?> getCurrentUser() async {
    final token = await tokenManager.getToken();
    if (token == null) return null;

    // For mock purposes, return a dummy user
    return User(id: '1', email: 'user@example.com', name: 'John Doe');
  }
}