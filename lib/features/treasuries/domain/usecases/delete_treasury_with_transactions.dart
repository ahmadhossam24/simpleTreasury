import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';

class DeleteTreasuryUseCase {
  final TreasuriesRepository treasuryRepository;
  final TransactionsRepository transactionRepository;

  DeleteTreasuryUseCase(this.treasuryRepository, this.transactionRepository);

  Future<Either<Failure, Unit>> call(String treasuryId) async {
    // 1. Delete all transactions related to this treasury
    final txResult = await transactionRepository.deleteTransactionsByTreasuryId(
      treasuryId,
    );
    if (txResult.isLeft()) {
      final failure = txResult.fold(
        (f) => f,
        (_) => throw UnimplementedError(),
      );
      return Left(failure);
    }

    // 2. Delete the treasury itself
    return treasuryRepository.deleteTreasury(treasuryId);
  }
}
