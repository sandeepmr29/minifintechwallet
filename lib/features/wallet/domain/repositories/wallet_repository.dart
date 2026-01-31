import '../entities/transaction.dart';

/// Interface for wallet repository
abstract class WalletRepository {
  /// Get current wallet balance
  Future<double> getBalance();

  /// Get list of transactions (paginated if needed)
  Future<List<TransactionEntity>> getTransactions({int page = 1, int limit = 20});

  /// Add a new transaction
  Future<void> addTransaction(TransactionEntity transaction);

  /// Sync pending transactions with remote server
  Future<void> syncPendingTransactions();
}