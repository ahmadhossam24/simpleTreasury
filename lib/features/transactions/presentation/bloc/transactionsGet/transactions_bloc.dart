import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/core/strings/failures.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/get_all_transactions.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final GetAllTransactionsUsecase getTransactions;
  TransactionsBloc({required this.getTransactions})
    : super(TransactionsInitial()) {
    on<TransactionsEvent>((event, emit) async {
      if (event is GetTransactionsByTreasuryId) {
        emit(LoadingTransactionsState());
        final failureOrTransactions = await getTransactions(event.treasuryId);
        _mapFailureOrTransactionsToState(failureOrTransactions);
      } else if (event is RefreshTransactionsByTreasuryId) {
        emit(LoadingTransactionsState());
        final failureOrTransactions = await getTransactions(event.treasuryId);
        _mapFailureOrTransactionsToState(failureOrTransactions);
      }
    });
  }

  TransactionsState _mapFailureOrTransactionsToState(
    Either<Failure, List<Transaction>> either,
  ) {
    return either.fold(
      (failure) =>
          ErrorTransactionsState(message: _mapFailureToMessage(failure)),
      (transactions) => LoadedTransactionsState(transactions: transactions),
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
