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
