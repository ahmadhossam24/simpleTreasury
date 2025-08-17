import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/add_transaction.dart';

// Mock class
class MockTransactionsRepository extends Mock
    implements TransactionsRepository {}

void main() {
  late AddTransaction usecase;
  late MockTransactionsRepository mockRepository;

  final tTransaction = Transaction(
    id: '1',
    treasuryId: 'treasury123',
    title: 'Import Goods',
    value: 1000.0,
    date: DateTime(2025, 1, 1),
    type: TransactionType.import,
    deleted: false,
  );

  setUp(() {
    mockRepository = MockTransactionsRepository();
    usecase = AddTransaction(mockRepository);
  });

  test(
    'should call repository.addTransaction and return Right(Unit) on success',
    () async {
      // arrange
      when(
        () => mockRepository.addTransaction(any()),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(tTransaction);

      // assert
      expect(result, const Right(unit));
      verify(() => mockRepository.addTransaction(tTransaction)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Left(Failure) when repository fails', () async {
    // arrange
    const failure = DatabaseFailure('DB error');
    when(
      () => mockRepository.addTransaction(any()),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tTransaction);

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.addTransaction(tTransaction)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
