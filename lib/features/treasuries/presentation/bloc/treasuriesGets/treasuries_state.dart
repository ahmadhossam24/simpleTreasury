part of 'treasuries_bloc.dart';

sealed class TreasuriesState extends Equatable {
  const TreasuriesState();

  @override
  List<Object> get props => [];
}

final class TreasuriesInitial extends TreasuriesState {}

class LoadingTreasuriesWithTransactionsState extends TreasuriesState {}

class LoadedTreasuriesWithTransactionsState extends TreasuriesState {
  final List<TreasuryWithTransactions> treasuriesWithTransactions;

  const LoadedTreasuriesWithTransactionsState({
    required this.treasuriesWithTransactions,
  });

  @override
  List<Object> get props => [treasuriesWithTransactions];
}

class ErrorTreasuriesWithTransactionsState extends TreasuriesState {
  final String message;

  const ErrorTreasuriesWithTransactionsState({required this.message});

  @override
  List<Object> get props => [message];
}
