import '../../domain/entities/transaction.dart';

/// Base class for all Wallet events
abstract class WalletEvent {}

/// Triggered to load wallet balance and transactions
class LoadWalletEvent extends WalletEvent {}

/// Triggered to add a new transaction
class AddTransactionEvent extends WalletEvent {
  final TransactionEntity transaction;

  AddTransactionEvent(this.transaction);
}