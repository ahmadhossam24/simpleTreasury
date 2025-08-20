import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/delete_transaction.dart';

// Mock class
class MockTransactionsRepository extends Mock
    implements TransactionsRepository {}

void main() {
  late DeleteTransactionUsecase usecase;
  late MockTransactionsRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionsRepository();
    usecase = DeleteTransactionUsecase(mockRepository);
  });

  test(
    'should call repository.deleteTransaction and return Right(Unit) on success',
    () async {
      // arrange
      when(
        () => mockRepository.deleteTransaction(any()),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase("1");

      // assert
      expect(result, const Right(unit));
      verify(() => mockRepository.deleteTransaction("1")).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Left(Failure) when repository fails', () async {
    // arrange
    const failure = DatabaseFailure('DB error');
    when(
      () => mockRepository.deleteTransaction(any()),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase("1");

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.deleteTransaction("1")).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
