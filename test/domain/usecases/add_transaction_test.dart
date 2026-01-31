import 'package:flutter_test/flutter_test.dart';
import 'package:miniwalletfintechapp/features/wallet/domain/entities/transaction.dart';
import 'package:miniwalletfintechapp/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:miniwalletfintechapp/features/wallet/domain/usecases/add_transaction.dart';
import 'package:mocktail/mocktail.dart';


// Mock class
class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  // Initialize variables for test
  late MockWalletRepository mockRepository;
  late AddTransaction addTransaction;

  // Runs before each test
  setUp(() {
    mockRepository = MockWalletRepository();
    addTransaction = AddTransaction(mockRepository);
  });

  // Example test
  test('should throw exception if transaction amount is <= 0', () async {
    final transaction = TransactionEntity(
      id: '1',
      amount: 0,
      type: 'credit', status: '', timestamp: '',
    );

    expect(
          () => addTransaction.call(transaction),
      throwsA(isA<Exception>().having(
            (e) => e.toString(),
        'message',
        contains('Transaction amount must be greater than 0'),
      )),
    );
  });

  // Add other tests here...
}