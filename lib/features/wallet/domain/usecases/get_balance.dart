import '../repositories/wallet_repository.dart';

/// Use case to get current wallet balance
class GetBalance {
  final WalletRepository repository;

  GetBalance(this.repository);

  /// Executes the use case
  Future<double> call() async {
    return await repository.getBalance();
  }
}