import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/exceptions.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/data/dataSources/transaction_local_data_source.dart';
import 'package:simpletreasury/features/transactions/data/models/transaction_model.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/treasuries/data/dataSources/treasury_local_data_source.dart';
import 'package:simpletreasury/features/treasuries/data/models/treasury_model.dart';
import 'package:simpletreasury/features/treasuries/data/repositories/treasury_repository_impl.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury_with_transactions.dart';

class MockTreasuryLocalDataSource extends Mock
    implements TreasuryLocalDataSource {}

class MockTransactionLocalDataSource extends Mock
    implements TransactionLocalDataSource {}

void main() {
  late MockTransactionLocalDataSource mockTransactionDataSource;

  late TreasuriesRepositoryImpl treasuriesRepository;
  late MockTreasuryLocalDataSource mockTreasuryDataSource;

  final tTreasuryModel = TreasuryModel(
    id: '1',
    title: 'fatherDepit',
    deleted: false,
  );

  final tTransactionModel = TransactionModel(
    id: '1',
    treasuryId: 'treasury1',
    title: 'Test',
    value: 100,
    date: DateTime(2023, 1, 1),
    type: TransactionType.import,
    deleted: false,
  );

  final tTreasuryWithTransactions = TreasuryWithTransactions(
    treasury: tTreasuryModel,
    transactions: [tTransactionModel],
  );

  setUpAll(() {
    registerFallbackValue(tTransactionModel);
    registerFallbackValue(tTreasuryModel);
  });

  setUp(() {
    mockTransactionDataSource = MockTransactionLocalDataSource();
    mockTreasuryDataSource = MockTreasuryLocalDataSource();
    treasuriesRepository = TreasuriesRepositoryImpl(
      transactionLocalDataSource: mockTransactionDataSource,
      treasuryLocalDataSource: mockTreasuryDataSource,
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
  // addTreasury
  // ------------------------------
  runUnitMethodTests(
    description: 'addTreasury',
    callMethod: () => treasuriesRepository.addTreasury(tTreasuryModel),
    arrangeSuccess: () {
      when(
        () => mockTreasuryDataSource.addTreasury(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(
        () => mockTreasuryDataSource.addTreasury(any()),
      ).thenThrow(exception);
    },
  );

  // ------------------------------
  // deleteTeasury
  // ------------------------------
  runUnitMethodTests(
    description: 'deleteTeasury',
    callMethod: () => treasuriesRepository.deleteTreasury('1'),
    arrangeSuccess: () {
      when(
        () => mockTreasuryDataSource.deleteTreasury(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(
        () => mockTreasuryDataSource.deleteTreasury(any()),
      ).thenThrow(exception);
    },
  );

  // ------------------------------
  // softDeleteTreasury
  // ------------------------------
  runUnitMethodTests(
    description: 'softDeleteTreasury',
    callMethod: () => treasuriesRepository.softDeleteTreasury('1'),
    arrangeSuccess: () {
      when(
        () => mockTreasuryDataSource.softDeleteTreasury(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(
        () => mockTreasuryDataSource.softDeleteTreasury(any()),
      ).thenThrow(exception);
    },
  );

  // ------------------------------
  // undoSoftDeleteTreasury
  // ------------------------------
  runUnitMethodTests(
    description: 'undoSoftDeleteTreasury',
    callMethod: () => treasuriesRepository.undoSoftDeleteTreasury('1'),
    arrangeSuccess: () {
      when(
        () => mockTreasuryDataSource.undoSoftDeleteTreasury(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(
        () => mockTreasuryDataSource.undoSoftDeleteTreasury(any()),
      ).thenThrow(exception);
    },
  );

  // ------------------------------
  // updateTreasury
  // ------------------------------
  runUnitMethodTests(
    description: 'updateTreasury',
    callMethod: () => treasuriesRepository.updateTreasury(tTreasuryModel),
    arrangeSuccess: () {
      when(
        () => mockTreasuryDataSource.updateTreasury(any()),
      ).thenAnswer((_) async => unit);
    },
    arrangeThrow: (exception) {
      when(
        () => mockTreasuryDataSource.updateTreasury(any()),
      ).thenThrow(exception);
    },
  );

  // ------------------------------
  // getAllTreasuries
  // ------------------------------
  group('getAllTreasuries', () {
    final listModel = [tTreasuryModel];

    test('should return Right(list) when data source succeeds', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenAnswer((_) async => listModel);
      final result = await treasuriesRepository.getAllTreasuries();
      expect(result, Right(listModel));
    });

    test('should return CacheFailure on CacheException', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenThrow(CacheException('cache fail'));
      final result = await treasuriesRepository.getAllTreasuries();
      expect(result, Left(CacheFailure('cache fail')));
    });

    test('should return DatabaseFailure on DatabaseException', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenThrow(DatabaseException('db fail'));
      final result = await treasuriesRepository.getAllTreasuries();
      expect(result, Left(DatabaseFailure('db fail')));
    });

    test('should return UnexpectedFailure on UnexpectedException', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenThrow(UnexpectedException('unexpected fail'));
      final result = await treasuriesRepository.getAllTreasuries();
      expect(result, Left(UnexpectedFailure('unexpected fail')));
    });

    test('should return UnknownFailure on unknown exception', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenThrow(Exception('unknown'));
      final result = await treasuriesRepository.getAllTreasuries();
      expect(result, Left(UnknownFailure('Unknown error occurred')));
    });
  });

  // ------------------------------
  // getTreasuriesWithTransactions
  // ------------------------------
  group('getTreasuriesWithTransactions', () {
    final listModel = [tTreasuryWithTransactions];

    test('should return Right(list) when data source succeeds', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenAnswer((_) async => [tTreasuryModel]);

      when(
        () => mockTransactionDataSource.getAllTransactions(any()),
      ).thenAnswer((_) async => [tTransactionModel]);
      final result = await treasuriesRepository.getTreasuriesWithTransactions();
      expect(result.getOrElse(() => []), listModel);
    });

    test('should return CacheFailure on CacheException', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenThrow(CacheException('cache fail'));

      when(
        () => mockTransactionDataSource.getAllTransactions(any()),
      ).thenThrow(CacheException('cache fail'));
      final result = await treasuriesRepository.getTreasuriesWithTransactions();
      expect(result, Left(CacheFailure('cache fail')));
    });

    test('should return DatabaseFailure on DatabaseException', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenThrow(DatabaseException('db fail'));

      when(
        () => mockTransactionDataSource.getAllTransactions(any()),
      ).thenThrow(DatabaseException('db fail'));
      final result = await treasuriesRepository.getTreasuriesWithTransactions();
      expect(result, Left(DatabaseFailure('db fail')));
    });

    test('should return UnexpectedFailure on UnexpectedException', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenThrow(UnexpectedException('unexpected fail'));

      when(
        () => mockTransactionDataSource.getAllTransactions(any()),
      ).thenThrow(UnexpectedException('unexpected fail'));
      final result = await treasuriesRepository.getTreasuriesWithTransactions();
      expect(result, Left(UnexpectedFailure('unexpected fail')));
    });

    test('should return UnknownFailure on unknown exception', () async {
      when(
        () => mockTreasuryDataSource.getAllTreasuries(),
      ).thenThrow(Exception('unknown'));

      when(
        () => mockTransactionDataSource.getAllTransactions(any()),
      ).thenThrow(Exception('unknown'));
      final result = await treasuriesRepository.getTreasuriesWithTransactions();
      expect(result, Left(UnknownFailure('Unknown error occurred')));
    });
  });

  // ------------------------------
  // calculateBalanceOfTreasury
  // ------------------------------
  group('calculateBalanceOfTreasury', () {
    const tTreasuryId = '123';

    test('✅ returns Right(balance) when localDataSource succeeds', () async {
      // arrange
      const tBalance = 50.0;
      when(
        () => mockTreasuryDataSource.calculateBalanceOfTreasury(tTreasuryId),
      ).thenAnswer((_) async => tBalance);

      // act
      final result = await treasuriesRepository.calculateBalanceOfTreasury(
        tTreasuryId,
      );

      // assert
      expect(result, equals(const Right(tBalance)));
      verify(
        () => mockTreasuryDataSource.calculateBalanceOfTreasury(tTreasuryId),
      ).called(1);
      verifyNoMoreInteractions(mockTreasuryDataSource);
    });

    test('should return CacheFailure on CacheException', () async {
      when(
        () => mockTreasuryDataSource.calculateBalanceOfTreasury(tTreasuryId),
      ).thenThrow(CacheException('cache fail'));
      final result = await treasuriesRepository.calculateBalanceOfTreasury(
        tTreasuryId,
      );
      expect(result, Left(CacheFailure('cache fail')));
    });

    test('should return DatabaseFailure on DatabaseException', () async {
      when(
        () => mockTreasuryDataSource.calculateBalanceOfTreasury(tTreasuryId),
      ).thenThrow(DatabaseException('db fail'));
      final result = await treasuriesRepository.calculateBalanceOfTreasury(
        tTreasuryId,
      );
      expect(result, Left(DatabaseFailure('db fail')));
    });

    test('should return UnexpectedFailure on UnexpectedException', () async {
      when(
        () => mockTreasuryDataSource.calculateBalanceOfTreasury(tTreasuryId),
      ).thenThrow(UnexpectedException('unexpected fail'));
      final result = await treasuriesRepository.calculateBalanceOfTreasury(
        tTreasuryId,
      );
      expect(result, Left(UnexpectedFailure('unexpected fail')));
    });

    test('should return UnknownFailure on unknown exception', () async {
      when(
        () => mockTreasuryDataSource.calculateBalanceOfTreasury(tTreasuryId),
      ).thenThrow(Exception('unknown'));
      final result = await treasuriesRepository.calculateBalanceOfTreasury(
        tTreasuryId,
      );
      expect(result, Left(UnknownFailure('Unknown error occurred')));
    });
  });
}
