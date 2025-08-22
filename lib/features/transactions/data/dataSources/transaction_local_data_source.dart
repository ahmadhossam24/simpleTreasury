import 'package:dartz/dartz.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:simpletreasury/core/database/db_provider.dart';
import 'package:simpletreasury/core/error/exceptions.dart';
import 'package:simpletreasury/features/transactions/data/models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions(String treasuryId);

  Future<Unit> addTransaction(TransactionModel transactionModel);

  Future<Unit> updateTransaction(TransactionModel transactionModel);

  Future<Unit> deleteTransaction(String transactionId);
  Future<Unit> softDeleteTransaction(String transactionId);
  Future<Unit> undoSoftDeleteTransaction(String transactionId);
  Future<Unit> deleteTransactionsByTreasuryId(String treasuryId);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DBProvider _dbProvider;
  final Database? _testDb;

  // Default constructor → production, uses singleton DB
  TransactionLocalDataSourceImpl({DBProvider? dbProvider})
    : _dbProvider = dbProvider ?? DBProvider.instance,
      _testDb = null;

  // Named constructor → for tests, lets you inject an in-memory DB
  TransactionLocalDataSourceImpl.test(Database db)
    : _dbProvider = DBProvider.instance,
      _testDb = db;

  // Use test DB if provided, else default DBProvider
  Future<Database> get _db async => _testDb ?? await _dbProvider.database;

  @override
  Future<Unit> addTransaction(TransactionModel transactionModel) async {
    try {
      final db = await _db;
      await db.insert('transactions', {
        'id': transactionModel.id,
        'treasuryId': transactionModel.treasuryId,
        'title': transactionModel.title,
        'value': transactionModel.value,
        'date': transactionModel.date.millisecondsSinceEpoch,
        'type': transactionModel.type.index,
        'deleted': transactionModel.deleted ? 1 : 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return unit;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<Unit> deleteTransaction(String transactionId) async {
    try {
      final db = await _db;
      await db.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [transactionId],
      );
      return unit;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<Unit> deleteTransactionsByTreasuryId(String treasuryId) async {
    try {
      final db = await _db;
      await db.delete(
        'transactions',
        where: 'treasuryId = ?',
        whereArgs: [treasuryId],
      );
      return unit;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions(String treasuryId) async {
    try {
      final db = await _db;
      final maps = await db.query(
        'transactions',
        where: 'treasuryId = ?',
        whereArgs: [treasuryId],
        orderBy: 'date DESC',
      );
      return maps
          .map(
            (map) => TransactionModel.fromMap({
              'id': map['id'],
              'treasuryId': map['treasuryId'],
              'title': map['title'],
              'value': map['value'],
              'date': DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
              'type': TransactionType.values[map['type'] as int],
              'deleted': map['deleted'] == 1,
            }),
          )
          .toList();
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<Unit> softDeleteTransaction(String transactionId) async {
    try {
      final db = await _db;
      await db.update(
        'transactions',
        {'deleted': 1},
        where: 'id = ?',
        whereArgs: [transactionId],
      );
      return unit;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<Unit> undoSoftDeleteTransaction(String transactionId) async {
    try {
      final db = await _db;
      await db.update(
        'transactions',
        {'deleted': 0},
        where: 'id = ?',
        whereArgs: [transactionId],
      );
      return unit;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<Unit> updateTransaction(TransactionModel transactionModel) async {
    try {
      final db = await _db;
      await db.update(
        'transactions',
        {
          'title': transactionModel.title,
          'value': transactionModel.value,
          'date': transactionModel.date.millisecondsSinceEpoch,
          'type': transactionModel.type.index,
          'deleted': transactionModel.deleted ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [transactionModel.id],
      );
      return unit;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
