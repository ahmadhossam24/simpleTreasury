part of 'treasuries_add_edit_delete_bloc.dart';

sealed class TreasuriesAddEditDeleteEvent extends Equatable {
  const TreasuriesAddEditDeleteEvent();

  @override
  List<Object> get props => [];
}

class AddTreasuryEvent extends TreasuriesAddEditDeleteEvent {
  final Treasury treasury;

  AddTreasuryEvent({required this.treasury});

  @override
  List<Object> get props => [treasury];
}

class UpdateTreasuryEvent extends TreasuriesAddEditDeleteEvent {
  final Treasury treasury;

  UpdateTreasuryEvent({required this.treasury});

  @override
  List<Object> get props => [treasury];
}

class DeleteTreasuryEvent extends TreasuriesAddEditDeleteEvent {
  final String treasuryId;

  DeleteTreasuryEvent({required this.treasuryId});

  @override
  List<Object> get props => [treasuryId];
}

class SoftDeleteTreasuryEvent extends TreasuriesAddEditDeleteEvent {
  final String treasuryId;

  SoftDeleteTreasuryEvent({required this.treasuryId});

  @override
  List<Object> get props => [treasuryId];
}

class UndoSoftDeleteTreasuryEvent extends TreasuriesAddEditDeleteEvent {
  final String treasuryId;

  UndoSoftDeleteTreasuryEvent({required this.treasuryId});

  @override
  List<Object> get props => [treasuryId];
}
