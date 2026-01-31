import 'dart:math';
import 'dart:async';

/// Simulated remote API data source for authentication
class AuthRemoteDataSource {
  final Random _random = Random();

  /// Mock login API
  /// Returns a token string on success
  /// Throws exception on simulated failure
  Future<String> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return a mock token
    return 'mock_token_12345';
  }

  /// Mock logout API
  Future<void> logout(String token) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));


  }
}