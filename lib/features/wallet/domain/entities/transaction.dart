import 'package:equatable/equatable.dart';

/// Wallet transaction entity
class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final String type; // 'credit' or 'debit'
  final String status; // 'pending', 'synced', 'failed'
  final String timestamp;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, amount, type, status, timestamp];
}