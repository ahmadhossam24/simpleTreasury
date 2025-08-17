import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/exceptions.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/data/dataSources/transaction_local_data_source.dart';
import 'package:simpletreasury/features/transactions/data/models/transaction_model.dart';
import 'package:simpletreasury/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';

class MockTransactionLocalDataSource extends Mock
    implements TransactionLocalDataSource {}

void main() {
  late TransactionsRepositoryImpl repository;
  late MockTransactionLocalDataSource mockDataSource;

  final tTransactionModel = TransactionModel(
    id: '1',
    treasuryId: 'treasury1',
    title: 'Test',
    value: 100,
    date: DateTime(2023, 1, 1),
    type: TransactionType.import,
    deleted: false,
  );

  setUpAll(() {
    registerFallbackValue(tTransactionModel);
  });

  setUp(() {
    mockDataSource = MockTransactionLocalDataSource();
    repository = TransactionsRepositoryImpl(
      transactionLocalDataSource: mockDataSource,
    );
  });

  /// Helper to test methods that call `_getMessage`
  void runUnitMethodTests({
    required String description,
    required Future<Either<Failure, Unit>> Function() callMethod,
    required void Function() arrangeSuccess,
    required void Function(Exception) arrangeThrow,
  }) {
    group(description, () {
      test('should return Right(unit) when data source succeeds', () async {
        arrangeSuccess();
        final result = await callMethod();
        expect(result, const Right(unit));
      });

      test('should return CacheFailure when CacheException thrown', () async {
        arrangeThrow(CacheException('cache fail'));
        final result = await callMethod();
        expect(result, Left(CacheFailure('cache fail')));
      });

      test(
        'should return DatabaseFailure when DatabaseException thrown',
        () async {
          arrangeThrow(DatabaseException('db fail'));
          final result = await callMethod();
          expect(result, Left(DatabaseFailure('db fail')));
        },
      );

      test(
        'should return UnexpectedFailure when UnexpectedException thrown',
        () async {
          arrangeThrow(UnexpectedException('unexpected fail'));
          final result = await callMethod();
          expect(result, Left(UnexpectedFailure('unexpected fail')));
        },
      );

      test('should return UnknownFailure for any other exception', () async {
        arrangeThrow(Exception('unknown'));
        final result = await callMethod();
        expect(result, Left(UnknownFailure('Unknown error occurred')));
      });
    });
  }

  // ------------------------------
  // addTransaction
  // ------------------------------
  runUnitMethodTests(
    description: 'addTransaction',
    callMethod: () => repository.addTransaction(tTransactionModel),
    arrangeSuccess: () {
      when(
        () => mockDataSource.addTransaction(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(() => mockDataSource.addTransaction(any())).thenThrow(exception);
    },
  );

  // ------------------------------
  // deleteTransaction
  // ------------------------------
  runUnitMethodTests(
    description: 'deleteTransaction',
    callMethod: () => repository.deleteTransaction('1'),
    arrangeSuccess: () {
      when(
        () => mockDataSource.deleteTransaction(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(() => mockDataSource.deleteTransaction(any())).thenThrow(exception);
    },
  );

  // ------------------------------
  // deleteTransactionsByTreasuryId
  // ------------------------------
  runUnitMethodTests(
    description: 'deleteTransactionsByTreasuryId',
    callMethod: () => repository.deleteTransactionsByTreasuryId('treasury1'),
    arrangeSuccess: () {
      when(
        () => mockDataSource.deleteTransactionsByTreasuryId(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(
        () => mockDataSource.deleteTransactionsByTreasuryId(any()),
      ).thenThrow(exception);
    },
  );

  // ------------------------------
  // softDeleteTransaction
  // ------------------------------
  runUnitMethodTests(
    description: 'softDeleteTransaction',
    callMethod: () => repository.softDeleteTransaction('1'),
    arrangeSuccess: () {
      when(
        () => mockDataSource.softDeleteTransaction(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(
        () => mockDataSource.softDeleteTransaction(any()),
      ).thenThrow(exception);
    },
  );

  // ------------------------------
  // undoSoftDeleteTransaction
  // ------------------------------
  runUnitMethodTests(
    description: 'undoSoftDeleteTransaction',
    callMethod: () => repository.undoSoftDeleteTransaction('1'),
    arrangeSuccess: () {
      when(
        () => mockDataSource.undoSoftDeleteTransaction(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(
        () => mockDataSource.undoSoftDeleteTransaction(any()),
      ).thenThrow(exception);
    },
  );

  // ------------------------------
  // updateTransaction
  // ------------------------------
  runUnitMethodTests(
    description: 'updateTransaction',
    callMethod: () => repository.updateTransaction(tTransactionModel),
    arrangeSuccess: () {
      when(
        () => mockDataSource.updateTransaction(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(() => mockDataSource.updateTransaction(any())).thenThrow(exception);
    },
  );

  // ------------------------------
  // getAllTransactions
  // ------------------------------
  group('getAllTransactions', () {
    const treasuryId = 'treasury1';
    final listModel = [tTransactionModel];

    test('should return Right(list) when data source succeeds', () async {
      when(
        () => mockDataSource.getAllTransactions(treasuryId),
      ).thenAnswer((_) async => listModel);
      final result = await repository.getAllTransactions(treasuryId);
      expect(result, Right(listModel));
    });

    test('should return CacheFailure on CacheException', () async {
      when(
        () => mockDataSource.getAllTransactions(treasuryId),
      ).thenThrow(CacheException('cache fail'));
      final result = await repository.getAllTransactions(treasuryId);
      expect(result, Left(CacheFailure('cache fail')));
    });

    test('should return DatabaseFailure on DatabaseException', () async {
      when(
        () => mockDataSource.getAllTransactions(treasuryId),
      ).thenThrow(DatabaseException('db fail'));
      final result = await repository.getAllTransactions(treasuryId);
      expect(result, Left(DatabaseFailure('db fail')));
    });

    test('should return UnexpectedFailure on UnexpectedException', () async {
      when(
        () => mockDataSource.getAllTransactions(treasuryId),
      ).thenThrow(UnexpectedException('unexpected fail'));
      final result = await repository.getAllTransactions(treasuryId);
      expect(result, Left(UnexpectedFailure('unexpected fail')));
    });

    test('should return UnknownFailure on unknown exception', () async {
      when(
        () => mockDataSource.getAllTransactions(treasuryId),
      ).thenThrow(Exception('unknown'));
      final result = await repository.getAllTransactions(treasuryId);
      expect(result, Left(UnknownFailure('Unknown error occurred')));
    });
  });
}
