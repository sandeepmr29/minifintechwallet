import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../domain/entities/transaction.dart';


class WalletLocalDataSource {
  static const _databaseName = "wallet.db";
  static const _databaseVersion = 1;

  static const tableTransactions = 'transactions';
  static const columnId = 'id';
  static const columnAmount = 'amount';
  static const columnType = 'type';
  static const columnStatus = 'status';
  static const columnTimestamp = 'timestamp';

  static const tableBalance = 'balance';
  static const columnBalance = 'balance';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Transactions table
    await db.execute('''
      CREATE TABLE $tableTransactions (
        $columnId TEXT PRIMARY KEY,
        $columnAmount REAL NOT NULL,
        $columnType TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnTimestamp TEXT NOT NULL
      )
    ''');

    // Balance table (single row)
    await db.execute('''
      CREATE TABLE $tableBalance (
        $columnBalance REAL NOT NULL
      )
    ''');

    // Initialize balance to 0
    await db.insert(tableBalance, {columnBalance: 0.0});
  }

  /// Get current balance
  Future<double> getBalance() async {
    final db = await database;
    final result = await db.query(tableBalance, limit: 1);
    if (result.isNotEmpty) {
      return result.first[columnBalance] as double;
    }
    return 0.0;
  }

  /// Update balance
  Future<void> updateBalance(double balance) async {
    final db = await database;
    await db.update(tableBalance, {columnBalance: balance});
  }

  /// Insert a new transaction
  Future<void> insertTransaction(TransactionEntity transaction) async {
    print("TAG insert transaction rrr");
    print(transaction.status);
    print("Status9999999999999");
    final db = await database;
    await db.insert(tableTransactions, {
      columnId: transaction.id,
      columnAmount: transaction.amount,
      columnType: transaction.type,
      columnStatus: transaction.status,
      columnTimestamp: transaction.timestamp,
    });
  }

  /// Get all transactions
  Future<List<TransactionEntity>> getTransactions({int page = 1, int limit = 20}) async {
    print("TAG 33900 gggsss");
    final db = await database;
    final offset = (page - 1) * limit;
    final result = await db.query(
      tableTransactions,
      orderBy: '$columnTimestamp DESC',
      limit: limit,
      offset: offset,
    );
print("TAg 2290gi0004455");
    return result.map((e) => TransactionEntity(
      id: e[columnId] as String,
      amount: e[columnAmount] as double,
      type: e[columnType] as String,
      status: e[columnStatus] as String,
      timestamp: e[columnTimestamp] as String,
    )).toList();
  }

  /// Get pending transactions for sync
  Future<List<TransactionEntity>> getPendingTransactions() async {
    print("TAg 2290gi0003434344455");
    final db = await database;
    final result = await db.query(
      tableTransactions,
      where: '$columnStatus = ?',
      whereArgs: ['pending'],
    );

    return result.map((e) => TransactionEntity(
      id: e[columnId] as String,
      amount: e[columnAmount] as double,
      type: e[columnType] as String,
      status: e[columnStatus] as String,
      timestamp: e[columnTimestamp] as String,
    )).toList();
  }

  /// Update transaction status after sync
  Future<void> updateTransactionStatus(String id, String status) async {
    final db = await database;
    await db.update(
      tableTransactions,
      {columnStatus: status},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}