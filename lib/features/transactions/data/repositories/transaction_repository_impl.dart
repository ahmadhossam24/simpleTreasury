import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/data/dataSources/transaction_local_data_source.dart';
import 'package:simpletreasury/features/transactions/data/models/transaction_model.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:simpletreasury/core/error/exceptions.dart';

typedef DeleteOrAddOrUpdate = Future<Unit> Function();

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionLocalDataSource transactionLocalDataSource;

  TransactionsRepositoryImpl({required this.transactionLocalDataSource});

  @override
  Future<Either<Failure, Unit>> addTransaction(Transaction transaction) async {
    final TransactionModel transactionModel = TransactionModel(
      id: transaction.id,
      treasuryId: transaction.treasuryId,
      title: transaction.title,
      value: transaction.value,
      date: transaction.date,
      type: transaction.type,
      deleted: transaction.deleted,
    );
    return await _getMessage(() {
      return transactionLocalDataSource.addTransaction(transactionModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) async {
    return await _getMessage(() {
      return transactionLocalDataSource.deleteTransaction(id);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteTransactionsByTreasuryId(
    String treasuryId,
  ) async {
    return await _getMessage(() {
      return transactionLocalDataSource.deleteTransactionsByTreasuryId(
        treasuryId,
      );
    });
  }

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions(
    String treasuryId,
  ) async {
    try {
      final treasuryTransactions = await transactionLocalDataSource
          .getAllTransactions(treasuryId);
      return right(treasuryTransactions);
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
  Future<Either<Failure, Unit>> softDeleteTransaction(String id) async {
    return await _getMessage(() {
      return transactionLocalDataSource.softDeleteTransaction(id);
    });
  }

  @override
  Future<Either<Failure, Unit>> undoSoftDeleteTransaction(String id) async {
    return await _getMessage(() {
      return transactionLocalDataSource.undoSoftDeleteTransaction(id);
    });
  }

  @override
  Future<Either<Failure, Unit>> updateTransaction(
    Transaction transaction,
  ) async {
    final TransactionModel transactionModel = TransactionModel(
      id: transaction.id,
      treasuryId: transaction.treasuryId,
      title: transaction.title,
      value: transaction.value,
      date: transaction.date,
      type: transaction.type,
      deleted: transaction.deleted,
    );
    return await _getMessage(() {
      return transactionLocalDataSource.updateTransaction(transactionModel);
    });
  }
}

Future<Either<Failure, Unit>> _getMessage(
  DeleteOrAddOrUpdate deleteOrUpdateOrAddTransaction,
) async {
  try {
    await deleteOrUpdateOrAddTransaction();
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
