import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';

class UndoDeleteTreasuryUsecase {
  final TreasuriesRepository repository;

  UndoDeleteTreasuryUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String treasuryId) async {
    return await repository.undoSoftDeleteTreasury(treasuryId);
  }
}
