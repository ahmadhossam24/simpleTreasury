import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';

class AddTreasury {
  final TreasuriesRepository repository;

  AddTreasury(this.repository);

  Future<Either<Failure, Unit>> call(Treasury treasury) async {
    return await repository.addTreasury(treasury);
  }
}


// what to test and why :
// 1- Repository call delegation

// Ensure that when you call addTreasury(treasury), the use case forwards the call to repository.addTreasury(treasury).
// instructions : 
// checks it returns success
// checks repo called correctly
// ensures nothing else was called

//  Why: This guarantees that your use case isn’t skipping or altering the repository call.

// 2- Success case

//  If the repository returns Right(Unit), the use case also returns Right(Unit).

//  Why: Confirms correct propagation of successful results.

// 3- Failure case

//   If the repository returns Left(Failure), the use case also returns Left(Failure)

//  Why: Confirms that errors bubble up correctly without being swallowed/altered.