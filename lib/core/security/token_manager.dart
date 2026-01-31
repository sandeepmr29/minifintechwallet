import 'secure_storage_service.dart';
import '../constants/app_constants.dart';

/// Manages storing, retrieving, and deleting the auth token
class TokenManager {
  final SecureStorageService _secureStorage;

  TokenManager(this._secureStorage);

  /// Save token securely
  Future<void> saveToken(String token) async {
    await _secureStorage.write(AppConstants.tokenKey, token);
  }

  /// Retrieve token
  Future<String?> getToken() async {
    return await _secureStorage.read(AppConstants.tokenKey);
  }

  /// Delete token (logout)
  Future<void> deleteToken() async {
    await _secureStorage.delete(AppConstants.tokenKey);
  }

  /// Delete all stored data (optional, for full logout)
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}