import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/core/strings/failures.dart';
import 'package:simpletreasury/core/strings/messages.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/add_transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/soft_delete_transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/undo_soft_delete_transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/update_transaction.dart';

part 'transaction_add_edit_delete_event.dart';
part 'transaction_add_edit_delete_state.dart';

class TransactionAddEditDeleteBloc
    extends Bloc<TransactionAddEditDeleteEvent, TransactionAddEditDeleteState> {
  final AddTransaction addTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteTransactionUsecase deleteTransaction;
  final SoftDeleteTransactionUsecase softDeleteTransaction;
  final UndoDeleteTransactionUsecase undoSoftDeleteTransaction;
  TransactionAddEditDeleteBloc({
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.softDeleteTransaction,
    required this.undoSoftDeleteTransaction,
  }) : super(TransactionAddEditDeleteInitial()) {
    on<TransactionAddEditDeleteEvent>((event, emit) async {
      if (event is AddTransactionEvent) {
        emit(LoadingAddEditDeleteTransactionState());

        final failureOrDoneMessage = await addTransaction(event.transaction);

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            TRANSACTION_ADDED_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is UpdateTransactionEvent) {
        emit(LoadingAddEditDeleteTransactionState());

        final failureOrDoneMessage = await updateTransaction(event.transaction);

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            TRANSACTION_UPDATED_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is DeleteTransactionEvent) {
        emit(LoadingAddEditDeleteTransactionState());

        final failureOrDoneMessage = await deleteTransaction(
          event.transactionId,
        );

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            TRANSACTION_DELETED_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is SoftDeleteTransactionEvent) {
        emit(LoadingAddEditDeleteTransactionState());

        final failureOrDoneMessage = await softDeleteTransaction(
          event.transactionId,
        );

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            TRANSACTION_SOFT_DELETED_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is UndoSoftDeleteTransactionEvent) {
        emit(LoadingAddEditDeleteTransactionState());

        final failureOrDoneMessage = await undoSoftDeleteTransaction(
          event.transactionId,
        );

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            TRANSACTION_UNDO_SOFT_DELETED_SUCCESS_MESSAGE,
          ),
        );
      }
    });
  }

  TransactionAddEditDeleteState _eitherDoneMessageOrErrorState(
    Either<Failure, Unit> either,
    String message,
  ) {
    return either.fold(
      (failure) => ErrorAddEditDeleteTransactionState(
        message: _mapFailureToMessage(failure),
      ),
      (_) => MessageAddEditDeleteTransactionState(message: message),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DatabaseFailure:
        return DATABASE_ERROR_FAILURE_MESSAGE;
      default:
        return "Unexcpected Error, try again later.";
    }
  }
}
