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
/*
    // Simulate random failure (20% chance)
    if (_random.nextInt(100) < 20) {
      throw Exception('Network error. Please try again.');
    }
*/
    // Return a mock token
    return 'mock_token_12345';
  }

  /// Mock logout API
  Future<void> logout(String token) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate random failure (10% chance)
    /*
    if (_random.nextInt(100) < 10) {
      throw Exception('Network error during logout.');
    }
*/
    // Success: do nothing
  }
}