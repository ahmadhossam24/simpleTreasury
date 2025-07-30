import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';

class UndoDeleteTransactionUsecase {
  final TransactionsRepository repository;

  UndoDeleteTransactionUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String transactionId) async {
    return await repository.undoSoftDeleteTransaction(transactionId);
  }
}
