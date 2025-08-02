import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';

class GetAllTreasuriesUsecase {
  final TreasuriesRepository repository;
  final Treasury treasury;

  GetAllTreasuriesUsecase(this.repository, this.treasury);

  Future<Either<Failure, List<Treasury>>> call() async {
    return await repository.getAllTreasuries();
  }
}
