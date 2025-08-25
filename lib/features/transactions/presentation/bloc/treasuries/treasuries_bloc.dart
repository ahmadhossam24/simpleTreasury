import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'treasuries_event.dart';
part 'treasuries_state.dart';

class TreasuriesBloc extends Bloc<TreasuriesEvent, TreasuriesState> {
  TreasuriesBloc() : super(TreasuriesInitial()) {
    on<TreasuriesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
