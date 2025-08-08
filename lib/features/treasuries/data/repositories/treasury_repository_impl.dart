import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/core/error/exceptions.dart';
import 'package:simpletreasury/features/treasuries/data/dataSources/treasury_local_data_source.dart';
import 'package:simpletreasury/features/treasuries/data/models/treasury_model.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury_with_transactions.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';

typedef DeleteOrAddOrUpdate = Future<Unit> Function();

class TreasuriesRepositoryImpl implements TreasuriesRepository {
  final TreasuryLocalDataSource treasuryLocalDataSource;

  TreasuriesRepositoryImpl({required this.treasuryLocalDataSource});

  @override
  Future<Either<Failure, Unit>> addTreasury(Treasury treasury) async {
    final TreasuryModel treasuryModel = TreasuryModel(
      id: treasury.id,
      title: treasury.title,
      deleted: treasury.deleted,
    );
    return await _getMessage(() {
      return treasuryLocalDataSource.addTreasury(treasuryModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteTreasury(String id) async {
    return await _getMessage(() {
      return treasuryLocalDataSource.deleteTreasury(id);
    });
  }

  @override
  Future<Either<Failure, List<Treasury>>> getAllTreasuries() async {
    try {
      final treasuries = await treasuryLocalDataSource.getAllTreasuries();
      return right(treasuries);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, Unit>> softDeleteTreasury(String id) async {
    return await _getMessage(() {
      return treasuryLocalDataSource.softDeleteTreasury(id);
    });
  }

  @override
  Future<Either<Failure, Unit>> undoSoftDeleteTreasury(String id) async {
    return await _getMessage(() {
      return treasuryLocalDataSource.undoSoftDeleteTreasury(id);
    });
  }

  @override
  Future<Either<Failure, Unit>> updateTreasury(Treasury treasury) async {
    final TreasuryModel treasuryModel = TreasuryModel(
      id: treasury.id,
      title: treasury.title,
      deleted: treasury.deleted,
    );
    return await _getMessage(() {
      return treasuryLocalDataSource.updateTreasury(treasuryModel);
    });
  }

  @override
  Future<Either<Failure, List<TreasuryWithTransactions>>>
  getTreasuriesWithTransactions() async {
    try {
      final treasuriesWithTransactions = await treasuryLocalDataSource
          .getTreasuriesWithTransactions();
      return right(treasuriesWithTransactions);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateBalanceOfTreasury(String id) async {
    try {
      final balanceOfTreasury = await treasuryLocalDataSource
          .calculateBalanceOfTreasury(id);
      return right(balanceOfTreasury);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }
}

Future<Either<Failure, Unit>> _getMessage(
  DeleteOrAddOrUpdate deleteOrUpdateOrAddTreasury,
) async {
  try {
    await deleteOrUpdateOrAddTreasury();
    return right(unit);
  } on CacheException catch (e) {
    return Left(CacheFailure(e.message));
  } on DatabaseException catch (e) {
    return Left(DatabaseFailure(e.message));
  } on UnexpectedException catch (e) {
    return Left(UnexpectedFailure(e.message));
  } catch (e) {
    return Left(UnknownFailure('Unknown error occurred'));
  }
}
