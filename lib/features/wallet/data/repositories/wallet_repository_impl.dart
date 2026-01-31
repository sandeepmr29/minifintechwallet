import '../../domain/entities/transaction.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_local_data_source.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletLocalDataSource localDataSource;
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<double> getBalance() async {
    return await localDataSource.getBalance();
  }

  @override
  Future<List<TransactionEntity>> getTransactions({int page = 1, int limit = 20}) async {
    return await localDataSource.getTransactions(page: page, limit: limit);
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    // Insert locally as pending
    print("TAg 222 pppeeegggg");
    await localDataSource.insertTransaction(transaction);

    // Update balance optimistically
    double currentBalance = await localDataSource.getBalance();
    double newBalance = transaction.type == 'credit'
        ? currentBalance + transaction.amount
        : currentBalance - transaction.amount;

    if (newBalance < 0) {
      throw Exception('Insufficient balance');
    }

    await localDataSource.updateBalance(newBalance);

    // Try to sync with remote
    try {
      await remoteDataSource.addTransaction(transaction);
      await localDataSource.updateTransactionStatus(transaction.id, 'synced');
    } catch (e) {
      // Leave status as pending for later retry
      await localDataSource.updateTransactionStatus(transaction.id, 'pending');
    }
  }

  @override
  Future<void> syncPendingTransactions() async {
    print("TAg 2290565665 sync pending transactions 22900888777");
    final pending = await localDataSource.getPendingTransactions();

    if (pending.isEmpty) return;

    try {
      final syncedIds = await remoteDataSource.syncTransactions(pending);

      for (var id in syncedIds) {
        await localDataSource.updateTransactionStatus(id, 'synced');
      }
    } catch (e) {
      // Network failed, do nothing; pending transactions remain for next sync
    }
  }
}