import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/core/strings/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury_with_transactions.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/get_treasuries_with_transactions.dart';

part 'treasuries_event.dart';
part 'treasuries_state.dart';

class TreasuriesBloc extends Bloc<TreasuriesEvent, TreasuriesState> {
  final GetTreasuriesWithTransactions getTreasuriesWithTransactions;
  TreasuriesBloc({required this.getTreasuriesWithTransactions})
    : super(TreasuriesInitial()) {
    on<TreasuriesEvent>((event, emit) async {
      if (event is getTreasuriesWithTransactionsEvent) {
        emit(LoadingTreasuriesWithTransactionsState());
        final failureOrTreasuriesWithTransactions =
            await getTreasuriesWithTransactions();
        _mapFailureOrTreasuriesWithTransactionsToState(
          failureOrTreasuriesWithTransactions,
        );
      } else if (event is refreshTreasuriesWithTransactionsEvent) {
        emit(LoadingTreasuriesWithTransactionsState());
        final failureOrTreasuriesWithTransactions =
            await getTreasuriesWithTransactions();
        _mapFailureOrTreasuriesWithTransactionsToState(
          failureOrTreasuriesWithTransactions,
        );
      }
    });
  }

  TreasuriesState _mapFailureOrTreasuriesWithTransactionsToState(
    Either<Failure, List<TreasuryWithTransactions>> either,
  ) {
    return either.fold(
      (failure) => ErrorTreasuriesWithTransactionsState(
        message: _mapFailureToMessage(failure),
      ),
      (treasuriesWithTransactions) => LoadedTreasuriesWithTransactionsState(
        treasuriesWithTransactions: treasuriesWithTransactions,
      ),
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
