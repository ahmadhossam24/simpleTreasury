import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:simpletreasury/features/treasuries/data/datasources/treasury_local_data_source.dart';
import 'package:simpletreasury/features/treasuries/data/models/treasury_model.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';

void main() {
  late TreasuryLocalDataSourceImpl dataSource;
  late Database db;

  setUp(() async {
    // initialize ffi for unit tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // in-memory db
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    // create schema (same as DBProvider._onCreate)
    await db.execute('''
      CREATE TABLE treasuries (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        deleted INTEGER NOT NULL DEFAULT 0,
        date INTEGER
      )
    ''');

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

    dataSource = TreasuryLocalDataSourceImpl.test(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TreasuryLocalDataSource', () {
    final treasury = TreasuryModel(
      id: 't1',
      title: 'Main Treasury',
      deleted: false,
    );

    test('addTreasury should insert treasury into db', () async {
      await dataSource.addTreasury(treasury);

      final result = await db.query('treasuries');
      expect(result.length, 1);
      expect(result.first['id'], treasury.id);
      expect(result.first['title'], treasury.title);
      expect(result.first['deleted'], 0);
    });

    test('getAllTreasuries should return mapped treasury list', () async {
      await dataSource.addTreasury(treasury);

      final treasuries = await dataSource.getAllTreasuries();

      expect(treasuries.length, 1);
      expect(treasuries.first.id, treasury.id);
      expect(treasuries.first.title, treasury.title);
    });

    test('getAllTreasuries should return empty list when no data', () async {
      final treasuries = await dataSource.getAllTreasuries();

      expect(treasuries, isEmpty);
    });

    test('updateTreasury should update treasury row', () async {
      await dataSource.addTreasury(treasury);

      final updated = TreasuryModel(
        id: treasury.id,
        title: 'Updated Treasury',
        deleted: true,
      );
      await dataSource.updateTreasury(updated);

      final result = await db.query(
        'treasuries',
        where: 'id = ?',
        whereArgs: [treasury.id],
      );
      expect(result.first['title'], 'Updated Treasury');
      expect(result.first['deleted'], 1);
    });

    test('deleteTreasury should delete treasury row', () async {
      await dataSource.addTreasury(treasury);

      await dataSource.deleteTreasury(treasury.id);

      final result = await db.query('treasuries');
      expect(result, isEmpty);
    });

    test('softDeleteTreasury should set deleted=1', () async {
      await dataSource.addTreasury(treasury);

      await dataSource.softDeleteTreasury(treasury.id);

      final result = await db.query(
        'treasuries',
        where: 'id = ?',
        whereArgs: [treasury.id],
      );
      expect(result.first['deleted'], 1);
    });

    test('undoSoftDeleteTreasury should set deleted=0', () async {
      await dataSource.addTreasury(treasury);
      await dataSource.softDeleteTreasury(treasury.id);

      await dataSource.undoSoftDeleteTreasury(treasury.id);

      final result = await db.query(
        'treasuries',
        where: 'id = ?',
        whereArgs: [treasury.id],
      );
      expect(result.first['deleted'], 0);
    });

    test('calculateBalanceOfTreasury should return correct balance', () async {
      await dataSource.addTreasury(treasury);

      // add transactions
      await db.insert('transactions', {
        'id': 'tr1',
        'treasuryId': treasury.id,
        'title': 'Deposit',
        'value': 100.0,
        'date': DateTime.now().millisecondsSinceEpoch,
        'type': TransactionType.import.index,
        'deleted': 0,
      });
      await db.insert('transactions', {
        'id': 'tr2',
        'treasuryId': treasury.id,
        'title': 'Withdrawal',
        'value': 30.0,
        'date': DateTime.now().millisecondsSinceEpoch,
        'type': TransactionType.export.index,
        'deleted': 0,
      });

      final balance = await dataSource.calculateBalanceOfTreasury(treasury.id);

      expect(balance, 70.0);
    });

    test(
      'calculateBalanceOfTreasury should ignore deleted transactions',
      () async {
        await dataSource.addTreasury(treasury);

        await db.insert('transactions', {
          'id': 'tr1',
          'treasuryId': treasury.id,
          'title': 'Deposit',
          'value': 50.0,
          'date': DateTime.now().millisecondsSinceEpoch,
          'type': TransactionType.import.index,
          'deleted': 1, // ignored
        });

        final balance = await dataSource.calculateBalanceOfTreasury(
          treasury.id,
        );

        expect(balance, 0.0);
      },
    );
  });
}
