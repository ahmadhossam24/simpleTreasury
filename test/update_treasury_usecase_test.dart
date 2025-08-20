import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/update_treasuries.dart';

// Mock class
class MockTreasuriesRepository extends Mock implements TreasuriesRepository {}

void main() {
  late UpdateTreasury usecase;
  late MockTreasuriesRepository mockRepository;

  final tTreasury = Treasury(id: '1', title: 'fatherDept', deleted: false);

  setUp(() {
    mockRepository = MockTreasuriesRepository();
    usecase = UpdateTreasury(mockRepository);
  });

  test(
    'should call repository.updateTreasury and return Right(Unit) on success',
    () async {
      // arrange
      when(
        () => mockRepository.updateTreasury(tTreasury),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(tTreasury);

      // assert
      expect(result, const Right(unit));
      verify(() => mockRepository.updateTreasury(tTreasury)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Left(Failure) when repository fails', () async {
    // arrange
    const failure = DatabaseFailure('DB error');
    when(
      () => mockRepository.updateTreasury(tTreasury),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tTreasury);

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.updateTreasury(tTreasury)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
