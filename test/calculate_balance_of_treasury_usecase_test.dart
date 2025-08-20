import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/calculate_balance_of_treasury.dart';

class MockTreasuriesRepository extends Mock implements TreasuriesRepository {}

void main() {
  late CalculateBalanceOfTreasury usecase;
  late MockTreasuriesRepository mockRepository;

  final double bBalanceOfTreasury = 45.5;

  setUp(() {
    mockRepository = MockTreasuriesRepository();
    usecase = CalculateBalanceOfTreasury(mockRepository);
  });

  test(
    'should return a balance of treasury from the repository when successful',
    () async {
      // arrange
      when(
        () => mockRepository.calculateBalanceOfTreasury(any()),
      ).thenAnswer((_) async => Right(bBalanceOfTreasury));

      // act
      final result = await usecase("1");

      // assert
      expect(result, Right(bBalanceOfTreasury));
      verify(() => mockRepository.calculateBalanceOfTreasury("1")).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return a Failure when the repository fails', () async {
    // arrange
    const failure = DatabaseFailure('Database error');
    when(
      () => mockRepository.calculateBalanceOfTreasury(any()),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase("1");

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.calculateBalanceOfTreasury("1")).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
