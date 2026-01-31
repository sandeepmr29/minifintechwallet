import '../../domain/entities/transaction.dart';

/// Base class for all Wallet states
abstract class WalletState {}

/// Initial state before any action
class WalletInitial extends WalletState {}

/// State when wallet data is loading
class WalletLoading extends WalletState {}

/// State when wallet data is successfully loaded
class WalletLoaded extends WalletState {
  final double balance;
  final List<TransactionEntity> transactions;

  WalletLoaded({required this.balance, required this.transactions});
}

/// State when an error occurs
class WalletError extends WalletState {
  final String message;

  WalletError({required this.message});
}