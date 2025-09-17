part of 'treasuries_bloc.dart';

sealed class TreasuriesEvent extends Equatable {
  const TreasuriesEvent();

  @override
  List<Object> get props => [];
}

class getAllTreasuriesEvent extends TreasuriesEvent {}

class getTreasuriesWithTransactionsEvent extends TreasuriesEvent {}

class refreshTreasuriesWithTransactionsEvent extends TreasuriesEvent {}

class addTreasuryEvent extends TreasuriesEvent {}

class softDeleteTreasuryEvent extends TreasuriesEvent {}

class deleteTreasuryEvent extends TreasuriesEvent {}

class deleteTreasuryWithTransactionsEvent extends TreasuriesEvent {}

class editTreasuryTitleEvent extends TreasuriesEvent {}
