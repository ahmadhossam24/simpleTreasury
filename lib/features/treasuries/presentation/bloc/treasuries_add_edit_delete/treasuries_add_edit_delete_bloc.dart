import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/core/strings/failures.dart';
import 'package:simpletreasury/core/strings/messages.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/add_treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/delete_treasury_with_transactions.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/soft_delete_treasuries.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/undo_soft_delete_treasuries.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/update_treasuries.dart';

part 'treasuries_add_edit_delete_event.dart';
part 'treasuries_add_edit_delete_state.dart';

class TreasuriesAddEditDeleteBloc
    extends Bloc<TreasuriesAddEditDeleteEvent, TreasuriesAddEditDeleteState> {
  final AddTreasury addTreasury;
  final UpdateTreasury updateTreasury;
  final DeleteTreasuryUseCase deleteTreasuryWithTransactions;
  final SoftDeleteTreasuryUsecase softDeleteTreasury;
  final UndoDeleteTreasuryUsecase undoSoftDeleteTreasury;
  TreasuriesAddEditDeleteBloc({
    required this.addTreasury,
    required this.updateTreasury,
    required this.deleteTreasuryWithTransactions,
    required this.softDeleteTreasury,
    required this.undoSoftDeleteTreasury,
  }) : super(TreasuriesAddEditDeleteInitial()) {
    on<TreasuriesAddEditDeleteEvent>((event, emit) async {
      if (event is AddTreasuryEvent) {
        emit(LoadingAddEditDeleteTreasuryState());

        final failureOrDoneMessage = await addTreasury(event.treasury);

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            ADDED_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is UpdateTreasuryEvent) {
        emit(LoadingAddEditDeleteTreasuryState());

        final failureOrDoneMessage = await updateTreasury(event.treasury);

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            UPDATED_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is DeleteTreasuryEvent) {
        emit(LoadingAddEditDeleteTreasuryState());

        final failureOrDoneMessage = await deleteTreasuryWithTransactions(
          event.treasuryId,
        );

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            DELETED_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is SoftDeleteTreasuryEvent) {
        emit(LoadingAddEditDeleteTreasuryState());

        final failureOrDoneMessage = await softDeleteTreasury(event.treasuryId);

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            SOFT_DELETED_SUCCESS_MESSAGE,
          ),
        );
      } else if (event is UndoSoftDeleteTreasuryEvent) {
        emit(LoadingAddEditDeleteTreasuryState());

        final failureOrDoneMessage = await undoSoftDeleteTreasury(
          event.treasuryId,
        );

        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            UNDO_SOFT_DELETED_SUCCESS_MESSAGE,
          ),
        );
      }
    });
  }

  TreasuriesAddEditDeleteState _eitherDoneMessageOrErrorState(
    Either<Failure, Unit> either,
    String message,
  ) {
    return either.fold(
      (failure) => ErrorAddEditDeleteTreasuryState(
        message: _mapFailureToMessage(failure),
      ),
      (_) => MessageAddEditDeleteTreasuryState(message: message),
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
