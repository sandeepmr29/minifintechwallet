import '../entities/transaction.dart';
import '../repositories/wallet_repository.dart';

/// Use case to add a new transaction
class AddTransaction {
  final WalletRepository repository;

  AddTransaction(this.repository);

  /// Executes the use case
  /// Throws exception if transaction fails
  Future<void> call(TransactionEntity transaction) async {
    // Domain-level validation: amount must be > 0
    if (transaction.amount <= 0) {
      throw Exception('Transaction amount must be greater than 0');
    }

    // Type validation
    if (transaction.type != 'credit' && transaction.type != 'debit') {
      throw Exception('Transaction type must be credit or debit');
    }

    // Call repository to add transaction
    await repository.addTransaction(transaction);
  }
}