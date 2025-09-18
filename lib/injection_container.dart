import 'package:get_it/get_it.dart';
import 'package:simpletreasury/core/database/db_provider.dart';
import 'package:simpletreasury/features/transactions/data/dataSources/transaction_local_data_source.dart';
import 'package:simpletreasury/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/add_transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/get_all_transactions.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/soft_delete_transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/undo_soft_delete_transaction.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/update_transaction.dart';
import 'package:simpletreasury/features/transactions/presentation/bloc/transactionsAddEditDelete/transaction_add_edit_delete_bloc.dart';
import 'package:simpletreasury/features/transactions/presentation/bloc/transactionsGet/transactions_bloc.dart';
import 'package:simpletreasury/features/treasuries/data/dataSources/treasury_local_data_source.dart';
import 'package:simpletreasury/features/treasuries/data/repositories/treasury_repository_impl.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/add_treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/delete_treasury_with_transactions.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/get_treasuries_with_transactions.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/soft_delete_treasuries.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/undo_soft_delete_treasuries.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/update_treasuries.dart';
import 'package:simpletreasury/features/treasuries/presentation/bloc/treasuriesGets/treasuries_bloc.dart';
import 'package:simpletreasury/features/treasuries/presentation/bloc/treasuries_add_edit_delete/treasuries_add_edit_delete_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features . Treasuries . Transactions

  // bloc

  sl.registerFactory(() => TreasuriesBloc(getTreasuriesWithTransactions: sl()));
  sl.registerFactory(
    () => TreasuriesAddEditDeleteBloc(
      addTreasury: sl(),
      updateTreasury: sl(),
      deleteTreasuryWithTransactions: sl(),
      softDeleteTreasury: sl(),
      undoSoftDeleteTreasury: sl(),
    ),
  );
  sl.registerFactory(() => TransactionsBloc(getTransactions: sl()));
  sl.registerFactory(
    () => TransactionAddEditDeleteBloc(
      addTransaction: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
      softDeleteTransaction: sl(),
      undoSoftDeleteTransaction: sl(),
    ),
  );

  // usecases

  sl.registerLazySingleton(() => GetTreasuriesWithTransactions(sl()));
  sl.registerLazySingleton(() => AddTreasury(sl()));
  sl.registerLazySingleton(() => UpdateTreasury(sl()));
  sl.registerLazySingleton(() => DeleteTreasuryUseCase(sl(), sl()));
  sl.registerLazySingleton(() => SoftDeleteTreasuryUsecase(sl()));
  sl.registerLazySingleton(() => UndoDeleteTreasuryUsecase(sl()));

  sl.registerFactoryParam<GetAllTransactionsUsecase, String, void>(
    (treasuryId, _) => GetAllTransactionsUsecase(treasuryId, sl()),
  ); //we Used a Factory Instead of Singleton Since treasuryId is dynamic and likely comes from runtime (e.g., user selection or navigation), you should register a factory that allows you to pass treasuryId when creating the use case and we can use it at run time>> final usecase = sl<GetAllTransactionsUsecase>(param1: treasuryId);
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransactionUsecase(sl()));
  sl.registerLazySingleton(() => SoftDeleteTransactionUsecase(sl()));
  sl.registerLazySingleton(() => UndoDeleteTransactionUsecase(sl()));

  // repository

  sl.registerLazySingleton<TreasuriesRepository>(
    () => TreasuriesRepositoryImpl(
      transactionLocalDataSource: sl(),
      treasuryLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<TransactionsRepository>(
    () => TransactionsRepositoryImpl(transactionLocalDataSource: sl()),
  );

  // datasources

  sl.registerLazySingleton<TreasuryLocalDataSource>(
    () => TreasuryLocalDataSourceImpl(dbProvider: sl()),
  );

  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(dbProvider: sl()),
  );

  //! Core

  sl.registerLazySingleton<DBProvider>(() => DBProvider());

  //! External
}
