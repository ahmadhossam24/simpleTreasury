import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:simpletreasury/features/transactions/domain/usecases/get_all_transactions.dart';

class MockTransactionsRepository extends Mock
    implements TransactionsRepository {}

void main() {
  late GetAllTransactionsUsecase usecase;
  late MockTransactionsRepository mockRepository;

  // A sample transaction entity just to provide treasuryId for the use case
  final tTransaction = Transaction(
    id: '1',
    treasuryId: 'treasury123',
    title: 'Sample Transaction',
    value: 100.0,
    date: DateTime(2025, 8, 12),
    type: TransactionType.import,
    deleted: false,
  );

  final tTransactionsList = [tTransaction];

  setUp(() {
    mockRepository = MockTransactionsRepository();
    usecase = GetAllTransactionsUsecase(tTransaction.id, mockRepository);
  });

  test(
    'should return a list of transactions from the repository when successful',
    () async {
      // arrange
      when(
        () => mockRepository.getAllTransactions(any()),
      ).thenAnswer((_) async => Right(tTransactionsList));

      // act
      final result = await usecase(tTransaction.id);

      // assert
      expect(result, Right(tTransactionsList));
      verify(() => mockRepository.getAllTransactions(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return a Failure when the repository fails', () async {
    // arrange
    const failure = DatabaseFailure('Database error');
    when(
      () => mockRepository.getAllTransactions(any()),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tTransaction.id);

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.getAllTransactions(any())).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
