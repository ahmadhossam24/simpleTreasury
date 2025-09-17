part of 'transaction_add_edit_delete_bloc.dart';

sealed class TransactionAddEditDeleteEvent extends Equatable {
  const TransactionAddEditDeleteEvent();

  @override
  List<Object> get props => [];
}

class AddTransactionEvent extends TransactionAddEditDeleteEvent {
  final Transaction transaction;

  AddTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class UpdateTransactionEvent extends TransactionAddEditDeleteEvent {
  final Transaction transaction;

  UpdateTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class DeleteTransactionEvent extends TransactionAddEditDeleteEvent {
  final String transactionId;

  DeleteTransactionEvent({required this.transactionId});

  @override
  List<Object> get props => [transactionId];
}

class SoftDeleteTransactionEvent extends TransactionAddEditDeleteEvent {
  final String transactionId;

  SoftDeleteTransactionEvent({required this.transactionId});

  @override
  List<Object> get props => [transactionId];
}

class UndoSoftDeleteTransactionEvent extends TransactionAddEditDeleteEvent {
  final String transactionId;

  UndoSoftDeleteTransactionEvent({required this.transactionId});

  @override
  List<Object> get props => [transactionId];
}
