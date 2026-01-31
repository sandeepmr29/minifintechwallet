import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../sync/sync_bloc.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/get_balance.dart';
import '../../domain/usecases/get_transactions.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';
import '../../../sync/sync_event.dart';



class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetBalance getBalanceUseCase;
  final GetTransactions getTransactionsUseCase;
  final AddTransaction addTransactionUseCase;
  final SyncBloc syncBloc;
  WalletBloc({
    required this.getBalanceUseCase,
    required this.getTransactionsUseCase,
    required this.addTransactionUseCase,
    required this.syncBloc
  }) : super(WalletInitial()) {
    on<LoadWalletEvent>(_onLoadWallet);
    on<AddTransactionEvent>(_onAddTransaction);
  }

  // ----------------------------
  // LOAD WALLET
  // ----------------------------
  Future<void> _onLoadWallet(
      LoadWalletEvent event,
      Emitter<WalletState> emit,
      ) async {
    emit(WalletLoading());

    try {
      final balance = await getBalanceUseCase();
      final transactions = await getTransactionsUseCase();

      emit(WalletLoaded(
        balance: balance,
        transactions: transactions,
      ));
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  // ----------------------------
  // ADD TRANSACTION
  // ----------------------------
  Future<void> _onAddTransaction(
      AddTransactionEvent event,
      Emitter<WalletState> emit,
      ) async {
    final currentState = state;

    // 🚨 HARD GUARD (no silent failure)
    if (currentState is! WalletLoaded) {
      emit( WalletError(message: 'Wallet not loaded'));
      return;
    }

    final double updatedBalance =
    event.transaction.type == 'credit'
        ? currentState.balance + event.transaction.amount
        : currentState.balance - event.transaction.amount;

    if (updatedBalance < 0) {
      emit( WalletError(message: 'Insufficient balance'));
      return;
    }

    final updatedTransactions = [
      event.transaction,
      ...currentState.transactions,
    ];

    // ✅ Optimistic update
    emit(WalletLoaded(
      balance: updatedBalance,
      transactions: updatedTransactions,
    ));

    try {
      await addTransactionUseCase(event.transaction);
      syncBloc.add(SyncPendingTransactionsEvent());
    } catch (e) {
      // In real fintech apps → rollback or mark failed
      emit(WalletError(message: e.toString()));
    }
  }
}