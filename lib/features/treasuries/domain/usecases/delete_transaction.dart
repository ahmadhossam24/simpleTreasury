import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';

class DeleteTreasuryUsecase {
  final TreasuriesRepository repository;

  DeleteTreasuryUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String treasuryId) async {
    return await repository.deleteTreasury(treasuryId);
  }
}
