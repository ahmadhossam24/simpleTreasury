part of 'treasuries_bloc.dart';

sealed class TreasuriesEvent extends Equatable {
  const TreasuriesEvent();

  @override
  List<Object> get props => [];
}

class getTreasuriesWithTransactionsEvent extends TreasuriesEvent {}

class refreshTreasuriesWithTransactionsEvent extends TreasuriesEvent {}
