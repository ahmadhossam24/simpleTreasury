import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';

class DeleteTransactionsByTreasuryIdUseCase {
  final TransactionsRepository repository;

  DeleteTransactionsByTreasuryIdUseCase(this.repository);

  Future<Either<Failure, void>> call(String treasuryId) {
    return repository.deleteTransactionsByTreasuryId(treasuryId);
  }
}
