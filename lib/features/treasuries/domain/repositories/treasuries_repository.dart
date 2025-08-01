import 'package:simpletreasury/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';

abstract class TreasuriesRepository {
  Future<Either<Failure, List<Treasury>>> getAllTreasuries();
  Future<Either<Failure, Unit>> deleteTreasury(String id);
  Future<Either<Failure, Unit>> softDeleteTreasury(String id);
  Future<Either<Failure, Unit>> undoSoftDeleteTreasury(String id);
  Future<Either<Failure, Unit>> updateTreasury(Treasury treasury);
  Future<Either<Failure, Unit>> addTreasury(Treasury treasury);
}
