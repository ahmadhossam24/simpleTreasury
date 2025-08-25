part of 'treasuries_bloc.dart';

sealed class TreasuriesState extends Equatable {
  const TreasuriesState();
  
  @override
  List<Object> get props => [];
}

final class TreasuriesInitial extends TreasuriesState {}
