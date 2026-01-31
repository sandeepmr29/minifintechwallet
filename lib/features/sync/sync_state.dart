/// Base class for sync states
abstract class SyncState {}

/// Initial state
class SyncInitial extends SyncState {}

/// State when syncing is in progress
class SyncInProgress extends SyncState {}

/// State when syncing is successful
class SyncSuccess extends SyncState {
  final int syncedCount;

  SyncSuccess({required this.syncedCount});
}

/// State when syncing failed
class SyncFailure extends SyncState {
  final String message;

  SyncFailure({required this.message});
}