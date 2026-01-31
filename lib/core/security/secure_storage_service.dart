import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service to securely store key-value pairs
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Write a value to secure storage
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a value from secure storage
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a value from secure storage
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all values (useful for logout)
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}