import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/delete_treasury.dart';

// Mock class
class MockTreasuriesRepository extends Mock implements TreasuriesRepository {}

void main() {
  late DeleteTreasuryUsecase usecase;
  late MockTreasuriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTreasuriesRepository();
    usecase = DeleteTreasuryUsecase(mockRepository);
  });

  test(
    'should call repository.deleteTreasury and return Right(Unit) on success',
    () async {
      // arrange
      when(
        () => mockRepository.deleteTreasury(any()),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase("1");

      // assert
      expect(result, const Right(unit));
      verify(() => mockRepository.deleteTreasury("1")).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Left(Failure) when repository fails', () async {
    // arrange
    const failure = DatabaseFailure('DB error');
    when(
      () => mockRepository.deleteTreasury(any()),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase("1");

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.deleteTreasury("1")).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
