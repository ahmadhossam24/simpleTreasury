import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/data/dataSources/transaction_local_data_source.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionLocalDataSource transactionLocalDataSource;

  TransactionsRepositoryImpl({required this.transactionLocalDataSource});

  @override
  Future<Either<Failure, Unit>> addTransaction(Transaction transaction) {
    // TODO: implement addTransaction
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) {
    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> deleteTransactionsByTreasuryId(
    String treasuryId,
  ) {
    // TODO: implement deleteTransactionsByTreasuryId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions(
    String treasuryId,
  ) async {
    try{
      final treasuryTransactions=await transactionLocalDataSource.getAllTransactions(treasuryId);
      return right(treasuryTransactions);
    } on {// here you should call an exception that you should implement in exceptions, ask gpt for suitable exception
      return left()// here you should call an failure that you should implement in failures, ask gpt for suitable failure
    }
  }

  @override
  Future<Either<Failure, Unit>> softDeleteTransaction(String id) {
    // TODO: implement softDeleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> undoSoftDeleteTransaction(String id) {
    // TODO: implement undoSoftDeleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateTransaction(Transaction transaction) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }
}
