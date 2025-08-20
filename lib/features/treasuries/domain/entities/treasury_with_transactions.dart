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

// what to test here and why 
// 1- Test that two Treasury objects with the same field values are considered equal.
// Test that changing one field makes them unequal.
// Reason: ensures Equatable is wired correctly with props.
// 2- Treasury props contains all fields