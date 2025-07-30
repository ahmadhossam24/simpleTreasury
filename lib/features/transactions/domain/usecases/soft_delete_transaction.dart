import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';

class SoftDeleteTransactionUsecase {
  final TransactionsRepository repository;

  SoftDeleteTransactionUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String transactionId) async {
    return await repository.softDeleteTransaction(transactionId);
  }
}
