import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/sync_service.dart';
import 'sync_event.dart';
import 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncService syncService;

  SyncBloc({required this.syncService}) : super(SyncInitial()) {
    // Handle sync trigger event
    on<SyncPendingTransactionsEvent>((event, emit) async {
      print("TAg 222997878787");
      emit(SyncInProgress());

      try {
        print("TAg 222997878787");
        final syncedCount = await syncService.syncPendingTransactions();
        emit(SyncSuccess(syncedCount: syncedCount));
      } catch (e) {
        print("TAg 222222222227878787");
        emit(SyncFailure(message: e.toString()));
      }
    });
  }
}