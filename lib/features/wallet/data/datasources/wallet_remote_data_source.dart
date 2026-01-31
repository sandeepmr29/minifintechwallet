import 'dart:async';
import 'dart:math';

import '../../domain/entities/transaction.dart';

/// Simulated remote API for wallet transactions
class WalletRemoteDataSource {
  final Random _random = Random();

  /// Simulate adding a transaction remotely
  /// Returns true if success, throws exception on failure
  Future<bool> addTransaction(TransactionEntity transaction) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate 20% failure rate
    if (_random.nextInt(100) < 20) {
      throw Exception('Network error while adding transaction');
    }

    return true; // success
  }

  /// Simulate syncing pending transactions
  /// Returns list of successfully synced transaction IDs
  Future<List<String>> syncTransactions(List<TransactionEntity> pending) async {
    await Future.delayed(const Duration(seconds: 3));

    List<String> syncedIds = [];

    for (var tx in pending) {
      // Simulate 80% success rate
      if (_random.nextInt(100) < 80) {
        syncedIds.add(tx.id);
      }
    }

    return syncedIds;
  }
}