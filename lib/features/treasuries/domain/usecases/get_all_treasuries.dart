import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';

class GetAllTreasuriesUsecase {
  final TreasuriesRepository repository;

  GetAllTreasuriesUsecase(this.repository);

  Future<Either<Failure, List<Treasury>>> call() async {
    return await repository.getAllTreasuries();
  }
}
