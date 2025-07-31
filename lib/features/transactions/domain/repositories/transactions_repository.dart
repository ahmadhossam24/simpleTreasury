import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:dartz/dartz.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, List<Transaction>>> getAllTransactions(
    String treasuryId,
  );
  Future<Either<Failure, Unit>> deleteTransaction(String id);
  Future<Either<Failure, Unit>> softDeleteTransaction(String id);
  Future<Either<Failure, Unit>> undoSoftDeleteTransaction(String id);
  Future<Either<Failure, Unit>> updateTransaction(Transaction transaction);
  Future<Either<Failure, Unit>> addTransaction(Transaction transaction);
}
