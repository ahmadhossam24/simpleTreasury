import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';

class GetAllTransactionsUsecase {
  final TransactionsRepository repository;
  final String treasuryId;

  GetAllTransactionsUsecase(this.treasuryId, this.repository);

  Future<Either<Failure, List<Transaction>>> call(treasuryId) async {
    return await repository.getAllTransactions(treasuryId);
  }
}
