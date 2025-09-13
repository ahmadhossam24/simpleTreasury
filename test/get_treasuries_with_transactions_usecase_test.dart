import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury_with_transactions.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/get_treasuries_with_transactions.dart';

class MockTreasuriesRepository extends Mock implements TreasuriesRepository {}

void main() {
  late GetTreasuriesWithTransactions usecase;
  late MockTreasuriesRepository mockRepository;

  final tTransaction = Transaction(
    id: '1',
    treasuryId: 'treasury123',
    title: 'Sample Transaction',
    value: 100.0,
    date: DateTime(2025, 8, 12),
    type: TransactionType.import,
    deleted: false,
  );
  final tTreasury = Treasury(id: '1', title: 'Sample Treasury', deleted: false);

  final double balance = 87;

  final tTreasuryWithTransaction = TreasuryWithTransactions(
    treasury: tTreasury,
    balance: balance,
    transactions: [tTransaction],
  );

  final tTreasuriesWithTransactionsList = [tTreasuryWithTransaction];

  setUp(() {
    mockRepository = MockTreasuriesRepository();
    usecase = GetTreasuriesWithTransactions(mockRepository);
  });

  test(
    'should return a list of treasuries from the repository when successful',
    () async {
      // arrange
      when(
        () => mockRepository.getTreasuriesWithTransactions(),
      ).thenAnswer((_) async => Right(tTreasuriesWithTransactionsList));

      // act
      final result = await usecase();

      // assert
      expect(result, Right(tTreasuriesWithTransactionsList));
      verify(() => mockRepository.getTreasuriesWithTransactions()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return a Failure when the repository fails', () async {
    // arrange
    const failure = DatabaseFailure('Database error');
    when(
      () => mockRepository.getTreasuriesWithTransactions(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.getTreasuriesWithTransactions()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
