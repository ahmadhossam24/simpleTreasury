import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';

class GetAllTransactionsUsecase {
  final TransactionsRepository repository;
  final Transaction transaction;

  GetAllTransactionsUsecase(this.repository, this.transaction);

  Future<Either<Failure, List<Transaction>>> call() async {
    return await repository.getAllTransactions(transaction.treasuryId);
  }
}
