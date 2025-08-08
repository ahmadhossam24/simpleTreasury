import 'package:dartz/dartz.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/treasuries/data/models/treasury_model.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:simpletreasury/core/database/db_provider.dart';
import 'package:simpletreasury/core/error/exceptions.dart';
import 'package:simpletreasury/features/transactions/data/models/transaction_model.dart';

abstract class TreasuryLocalDataSource {
  Future<List<TreasuryModel>> getAllTreasuries();
  Future<List<TreasuryWithTransactionsModel>> getTreasuriesWithTransactions();
  Future<Unit> calculateBalanceOfTreasury(String id);

  Future<Unit> addTreasury(TreasuryModel treasuryModel);

  Future<Unit> updateTreasury(TreasuryModel treasuryModel);

  Future<Unit> deleteTreasury(String treasuryId);
  Future<Unit> softDeleteTreasury(String treasuryId);
  Future<Unit> undoSoftDeleteTreasury(String treasuryId);
}

class TreasuryLocalDataSourceImpl implements TreasuryLocalDataSource {
  final DBProvider _dbProvider = DBProvider.instance;

  @override
  Future<Unit> addTreasury(TreasuryModel treasuryModel) async {
    try {
      final db = await _dbProvider.database;
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
      final db = await _dbProvider.database;
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
      final db = await _dbProvider.database;
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
      final db = await _dbProvider.database;
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
      final db = await _dbProvider.database;
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
      final db = await _dbProvider.database;
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
  Future<Either<Failure, List<TreasuryWithTransactions>>>
  getTreasuriesWithTransactions() {
    // TODO: implement getTreasuriesWithTransactions
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> calculateBalanceOfTreasury(String id) {
    // TODO: implement calculateBalanceOfTreasury
    throw UnimplementedError();
  }
}
