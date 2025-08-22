import 'package:dartz/dartz.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/treasuries/data/models/treasury_model.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:simpletreasury/core/database/db_provider.dart';
import 'package:simpletreasury/core/error/exceptions.dart';

abstract class TreasuryLocalDataSource {
  Future<List<TreasuryModel>> getAllTreasuries();
  Future<double> calculateBalanceOfTreasury(String id);

  Future<Unit> addTreasury(TreasuryModel treasuryModel);

  Future<Unit> updateTreasury(TreasuryModel treasuryModel);

  Future<Unit> deleteTreasury(String treasuryId);
  Future<Unit> softDeleteTreasury(String treasuryId);
  Future<Unit> undoSoftDeleteTreasury(String treasuryId);
}

class TreasuryLocalDataSourceImpl implements TreasuryLocalDataSource {
  final DBProvider _dbProvider;
  final Database? _testDb;

  TreasuryLocalDataSourceImpl({DBProvider? dbProvider})
    : _dbProvider = dbProvider ?? DBProvider.instance,
      _testDb = null;

  TreasuryLocalDataSourceImpl.test(
    Database db,
  ) // <-- THIS IS THE NAMED CONSTRUCTOR
  : _dbProvider = DBProvider.instance,
      _testDb = db;

  Future<Database> get _db async => _testDb ?? await _dbProvider.database;

  @override
  Future<Unit> addTreasury(TreasuryModel treasuryModel) async {
    try {
      final db = await _db;
      await db.insert('treasuries', {
        'id': treasuryModel.id,
        'title': treasuryModel.title,
        'deleted': treasuryModel.deleted ? 1 : 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return unit;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<Unit> deleteTreasury(String treasuryId) async {
    try {
      final db = await _db;
      await db.delete('treasuries', where: 'id = ?', whereArgs: [treasuryId]);
      return unit;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<TreasuryModel>> getAllTreasuries() async {
    try {
      final db = await _db;
      final maps = await db.query('treasuries', orderBy: 'date DESC');
      return maps
          .map(
            (map) => TreasuryModel.fromMap({
              'id': map['id'],
              'title': map['title'],
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
  Future<Unit> softDeleteTreasury(String treasuryId) async {
    try {
      final db = await _db;
      await db.update(
        'treasuries',
        {'deleted': 1},
        where: 'id = ?',
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
  Future<Unit> undoSoftDeleteTreasury(String treasuryId) async {
    try {
      final db = await _db;
      await db.update(
        'treasuries',
        {'deleted': 0},
        where: 'id = ?',
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
  Future<Unit> updateTreasury(TreasuryModel treasuryModel) async {
    try {
      final db = await _db;
      await db.update(
        'treasuries',
        {
          'title': treasuryModel.title,
          'deleted': treasuryModel.deleted ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [treasuryModel.id],
      );
      return unit;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<double> calculateBalanceOfTreasury(String id) async {
    try {
      final db = await _db;

      // fetch only 'value' and 'type' for active (deleted==0) transactions
      final maps = await db.query(
        'transactions',
        columns: ['value', 'type'],
        where: 'treasuryId = ? AND deleted = 0',
        whereArgs: [id],
      );

      // sum: imports add, exports subtract
      double balance = 0.0;
      for (final row in maps) {
        final value = (row['value'] as num).toDouble();
        final typeIndex = row['type'] as int;
        final type = TransactionType.values[typeIndex];
        balance += type == TransactionType.import ? value : -value;
      }

      return balance;
    } on DatabaseException catch (e) {
      throw DatabaseException(e.toString());
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
