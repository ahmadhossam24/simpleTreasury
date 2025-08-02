import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';

class UpdateTreasury {
  final TreasuriesRepository repository;

  UpdateTreasury(this.repository);

  Future<Either<Failure, Unit>> call(Treasury treasury) async {
    return await repository.updateTreasury(treasury);
  }
}
