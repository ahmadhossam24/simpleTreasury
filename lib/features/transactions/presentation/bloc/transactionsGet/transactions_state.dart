part of 'transactions_bloc.dart';

sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

final class TransactionsInitial extends TransactionsState {}

class LoadingTransactionsState extends TransactionsState {}

class LoadedTransactionsState extends TransactionsState {
  final List<Transaction> transactions;

  const LoadedTransactionsState({required this.transactions});

  @override
  List<Object> get props => [transactions];
}

class ErrorTransactionsState extends TransactionsState {
  final String message;

  const ErrorTransactionsState({required this.message});

  @override
  List<Object> get props => [message];
}
