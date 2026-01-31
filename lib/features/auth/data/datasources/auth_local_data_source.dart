import '../../../../core/security/token_manager.dart';
import '../../domain/entities/user.dart';

class AuthLocalDataSource {
  final TokenManager tokenManager;

  AuthLocalDataSource({required this.tokenManager});

  Future<void> saveToken(String token) async {
    await tokenManager.saveToken(token);
  }

  Future<String?> getToken() async {
    return await tokenManager.getToken();
  }

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
