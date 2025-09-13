import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
        final treasuriesWithTransactions =
            await getTreasuriesWithTransactions();
        treasuriesWithTransactions.fold(
          (failure) {},
          (treasuriesWithTransactions) {},
        );
      } else if (event is refreshTreasuriesWithTransactionsEvent) {}
    });
  }
}
