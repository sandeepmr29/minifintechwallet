import 'dart:async';

/// Retry a function [action] up to [retries] times with exponential backoff
Future<T> retry<T>(
    Future<T> Function() action, {
      int retries = 3,
      Duration delay = const Duration(seconds: 1),
    }) async {
  for (int attempt = 0; attempt < retries; attempt++) {
    try {
      return await action();
    } catch (e) {
      if (attempt == retries - 1) {
        // Last attempt failed, rethrow
        rethrow;
      }
      // Exponential backoff: multiply delay by attempt+1
      await Future.delayed(delay * (attempt + 1));
    }
  }
  throw Exception("Retry failed"); // Should never reach here
}