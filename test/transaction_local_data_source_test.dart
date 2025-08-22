import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:simpletreasury/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:simpletreasury/features/transactions/data/models/transaction_model.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';

void main() {
  late TransactionLocalDataSourceImpl dataSource;
  late Database db;

  setUp(() async {
    // Initialize ffi for unit tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // In-memory DB
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    // Create schema (match DBProvider._onCreate)
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        treasuryId TEXT NOT NULL,
        title TEXT,
        value REAL NOT NULL,
        date INTEGER NOT NULL,
        type INTEGER NOT NULL,
        deleted INTEGER NOT NULL DEFAULT 0
      )
    ''');

    dataSource = TransactionLocalDataSourceImpl.test(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TransactionLocalDataSource', () {
    test('addTransaction should insert a transaction', () async {
      final transaction = TransactionModel(
        id: '1',
        treasuryId: 't1',
        title: 'Test Tx',
        value: 100.0,
        date: DateTime(2025, 1, 1),
        type: TransactionType.import,
        deleted: false,
      );

      await dataSource.addTransaction(transaction);

      final results = await db.query('transactions');
      expect(results.length, 1);
      expect(results.first['title'], 'Test Tx');
    });

    test(
      'getAllTransactions should return transactions for treasuryId',
      () async {
        final tx1 = TransactionModel(
          id: '2',
          treasuryId: 't1',
          title: 'Tx 1',
          value: 50.0,
          date: DateTime(2025, 1, 2),
          type: TransactionType.export,
          deleted: false,
        );
        final tx2 = TransactionModel(
          id: '3',
          treasuryId: 't1',
          title: 'Tx 2',
          value: 30.0,
          date: DateTime(2025, 1, 3),
          type: TransactionType.export,
          deleted: false,
        );

        await dataSource.addTransaction(tx1);
        await dataSource.addTransaction(tx2);

        final results = await dataSource.getAllTransactions('t1');

        expect(results.length, 2);
        expect(results.first.title, 'Tx 2'); // ordered by date DESC
      },
    );

    test('updateTransaction should modify an existing transaction', () async {
      final tx = TransactionModel(
        id: '4',
        treasuryId: 't1',
        title: 'Old Title',
        value: 20.0,
        date: DateTime(2025, 1, 4),
        type: TransactionType.export,
        deleted: false,
      );

      await dataSource.addTransaction(tx);

      final updated = TransactionModel(
        id: '4',
        treasuryId: 't1',
        title: 'New Title',
        value: 99.0,
        date: DateTime(2025, 1, 5),
        type: TransactionType.import,
        deleted: false,
      );

      await dataSource.updateTransaction(updated);

      final results = await dataSource.getAllTransactions('t1');
      expect(results.first.title, 'New Title');
      expect(results.first.value, 99.0);
    });

    test('deleteTransaction should remove the row', () async {
      final tx = TransactionModel(
        id: '5',
        treasuryId: 't1',
        title: 'To Delete',
        value: 10.0,
        date: DateTime.now(),
        type: TransactionType.export,
        deleted: false,
      );

      await dataSource.addTransaction(tx);
      await dataSource.deleteTransaction('5');

      final results = await dataSource.getAllTransactions('t1');
      expect(results, isEmpty);
    });

    test('softDeleteTransaction should set deleted=1', () async {
      final tx = TransactionModel(
        id: '6',
        treasuryId: 't1',
        title: 'Soft Delete',
        value: 40.0,
        date: DateTime.now(),
        type: TransactionType.import,
        deleted: false,
      );

      await dataSource.addTransaction(tx);
      await dataSource.softDeleteTransaction('6');

      final rows = await db.query(
        'transactions',
        where: 'id = ?',
        whereArgs: ['6'],
      );
      expect(rows.first['deleted'], 1);
    });

    test('undoSoftDeleteTransaction should set deleted=0', () async {
      final tx = TransactionModel(
        id: '7',
        treasuryId: 't1',
        title: 'Undo Delete',
        value: 40.0,
        date: DateTime.now(),
        type: TransactionType.export,
        deleted: true,
      );

      await dataSource.addTransaction(tx);
      await dataSource.undoSoftDeleteTransaction('7');

      final rows = await db.query(
        'transactions',
        where: 'id = ?',
        whereArgs: ['7'],
      );
      expect(rows.first['deleted'], 0);
    });

    test(
      'deleteTransactionsByTreasuryId should remove all rows for treasury',
      () async {
        final tx1 = TransactionModel(
          id: '8',
          treasuryId: 't1',
          title: 'Tx A',
          value: 5.0,
          date: DateTime.now(),
          type: TransactionType.import,
          deleted: false,
        );
        final tx2 = TransactionModel(
          id: '9',
          treasuryId: 't1',
          title: 'Tx B',
          value: 15.0,
          date: DateTime.now(),
          type: TransactionType.export,
          deleted: false,
        );

        await dataSource.addTransaction(tx1);
        await dataSource.addTransaction(tx2);

        await dataSource.deleteTransactionsByTreasuryId('t1');

        final results = await dataSource.getAllTransactions('t1');
        expect(results, isEmpty);
      },
    );
  });
}
