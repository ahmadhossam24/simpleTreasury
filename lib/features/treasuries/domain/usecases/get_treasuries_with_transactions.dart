import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury_with_transactions.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';

class GetTreasuriesWithTransactions {
  final TreasuriesRepository repository;

  GetTreasuriesWithTransactions(this.repository);

  Future<Either<Failure, List<TreasuryWithTransactions>>> call() {
    return repository.getTreasuriesWithTransactions();
  }
}
