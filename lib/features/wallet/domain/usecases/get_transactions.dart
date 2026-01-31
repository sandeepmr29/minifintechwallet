import '../entities/transaction.dart';
import '../repositories/wallet_repository.dart';

/// Use case to get wallet transactions
class GetTransactions {
  final WalletRepository repository;

  GetTransactions(this.repository);

  /// Executes the use case
  /// Supports optional pagination
  Future<List<TransactionEntity>> call({int page = 1, int limit = 20}) async {
    return await repository.getTransactions(page: page, limit: limit);
  }
}