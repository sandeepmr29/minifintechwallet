/// Base class for sync events
abstract class SyncEvent {}

/// Event to trigger syncing of pending transactions
class SyncPendingTransactionsEvent extends SyncEvent {}