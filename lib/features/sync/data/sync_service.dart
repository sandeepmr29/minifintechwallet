

import '../../wallet/domain/repositories/wallet_repository.dart';

/// Service to handle syncing of pending transactions
class SyncService {
  final WalletRepository repository;

  SyncService({required this.repository});

  /// Sync all pending transactions with the remote server
  /// Returns number of successfully synced transactions
  Future<int> syncPendingTransactions() async {
    print("TAG sync pending transactions 222990000");
    // Get pending transactions from local storage
    final pendingTransactions = await repository.getTransactions();
    print('Pending transactions: $pendingTransactions');
    for (var tx in pendingTransactions) {
      print('Transaction: id=${tx.id}, amount=${tx.amount}, type=${tx.type}');
    }
    final pending = pendingTransactions
        .where((tx) => tx.status == 'pending')
        .toList();
print("TAg 222900ttto98989898");
    if (pending.isEmpty)
      {
        print("pending is empty 229000");
        return 0;
      }
    else{
      print("pending transactions 2290888");
    }

    try {
      await repository.syncPendingTransactions();
      print("TAG send pending transcactions 2290000");
      return pending.length;
    } catch (e) {
      // On failure, none are synced
      return 0;
    }
  }
}