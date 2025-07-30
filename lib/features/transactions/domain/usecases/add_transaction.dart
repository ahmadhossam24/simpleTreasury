import 'package:dartz/dartz.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';

class AddTransaction {
  final TransactionsRepository repository;

  AddTransaction(this.repository);

  Future<Either<Failure, Unit>> call(Transaction transaction) async {
    return await repository.addTransaction(transaction);
  }
}
