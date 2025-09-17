part of 'transaction_add_edit_delete_bloc.dart';

sealed class TransactionAddEditDeleteState extends Equatable {
  const TransactionAddEditDeleteState();

  @override
  List<Object> get props => [];
}

final class TransactionAddEditDeleteInitial
    extends TransactionAddEditDeleteState {}

final class LoadingAddEditDeleteTransactionState
    extends TransactionAddEditDeleteState {}

final class ErrorAddEditDeleteTransactionState
    extends TransactionAddEditDeleteState {
  final String message;

  ErrorAddEditDeleteTransactionState({required this.message});

  @override
  List<Object> get props => [message];
}

final class MessageAddEditDeleteTransactionState
    extends TransactionAddEditDeleteState {
  final String message;

  MessageAddEditDeleteTransactionState({required this.message});

  @override
  List<Object> get props => [message];
}
