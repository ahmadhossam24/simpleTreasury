part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

class GetTransactionsByTreasuryId extends TransactionsEvent {
  final String treasuryId;

  const GetTransactionsByTreasuryId({required this.treasuryId});

  @override
  List<Object> get props => [treasuryId];
}

class RefreshTransactionsByTreasuryId extends TransactionsEvent {
  final String treasuryId;

  const RefreshTransactionsByTreasuryId({required this.treasuryId});

  @override
  List<Object> get props => [treasuryId];
}
