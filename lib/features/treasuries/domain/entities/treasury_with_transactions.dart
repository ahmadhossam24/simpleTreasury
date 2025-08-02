import 'package:equatable/equatable.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';

class TreasuryWithTransactions extends Equatable {
  final Treasury treasury;
  final List<Transaction> transactions;

  const TreasuryWithTransactions({
    required this.treasury,
    required this.transactions,
  });

  @override
  List<Object?> get props => [treasury, transactions];
}
