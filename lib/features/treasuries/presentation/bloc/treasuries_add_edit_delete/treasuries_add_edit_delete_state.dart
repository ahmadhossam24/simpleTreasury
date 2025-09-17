part of 'treasuries_add_edit_delete_bloc.dart';

sealed class TreasuriesAddEditDeleteState extends Equatable {
  const TreasuriesAddEditDeleteState();

  @override
  List<Object> get props => [];
}

final class TreasuriesAddEditDeleteInitial
    extends TreasuriesAddEditDeleteState {}

final class LoadingAddEditDeleteTreasuryState
    extends TreasuriesAddEditDeleteState {}

final class ErrorAddEditDeleteTreasuryState
    extends TreasuriesAddEditDeleteState {
  final String message;

  ErrorAddEditDeleteTreasuryState({required this.message});

  @override
  List<Object> get props => [message];
}

final class MessageAddEditDeleteTreasuryState
    extends TreasuriesAddEditDeleteState {
  final String message;

  MessageAddEditDeleteTreasuryState({required this.message});

  @override
  List<Object> get props => [message];
}
