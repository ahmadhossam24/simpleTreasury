import 'package:dartz/dartz.dart';
import 'package:simpletreasury/features/transactions/data/models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions(String treasuryId);

  Future<Unit> addTransaction(TransactionModel transactionModel);

  Future<Unit> updateTransaction(TransactionModel transactionModel);

  Future<Unit> deleteTransaction(String transactionId);
  Future<Unit> softDeleteTransaction(String transactionId);
  Future<Unit> undoSoftDeleteTransaction(String transactionId);
  Future<Unit> deleteTransactionsByTreasuryId(String treasuryId);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  @override
  Future<Unit> addTransaction(TransactionModel transactionModel) {
    // TODO: implement addTransaction
    throw UnimplementedError();
  }

  @override
  Future<Unit> deleteTransaction(String transactionId) {
    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<Unit> deleteTransactionsByTreasuryId(String treasuryId) {
    // TODO: implement deleteTransactionsByTreasuryId
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions(treasuryId) {
    // TODO: implement getAllTransactions
    throw UnimplementedError();
  }

  @override
  Future<Unit> softDeleteTransaction(String transactionId) {
    // TODO: implement softDeleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<Unit> undoSoftDeleteTransaction(String transactionId) {
    // TODO: implement undoSoftDeleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<Unit> updateTransaction(TransactionModel transactionModel) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }
}
