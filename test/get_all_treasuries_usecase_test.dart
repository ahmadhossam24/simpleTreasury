import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/get_all_treasuries.dart';

class MockTreasuriesRepository extends Mock implements TreasuriesRepository {}

void main() {
  late GetAllTreasuriesUsecase usecase;
  late MockTreasuriesRepository mockRepository;

  // A sample treasury entity just to provide treasuryId for the use case
  final tTreasury = Treasury(id: '1', title: 'Sample Treasury', deleted: false);

  final tTreasuriesList = [tTreasury];

  setUp(() {
    mockRepository = MockTreasuriesRepository();
    usecase = GetAllTreasuriesUsecase(mockRepository);
  });

  test(
    'should return a list of treasuries from the repository when successful',
    () async {
      // arrange
      when(
        () => mockRepository.getAllTreasuries(),
      ).thenAnswer((_) async => Right(tTreasuriesList));

      // act
      final result = await usecase();

      // assert
      expect(result, Right(tTreasuriesList));
      verify(() => mockRepository.getAllTreasuries()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return a Failure when the repository fails', () async {
    // arrange
    const failure = DatabaseFailure('Database error');
    when(
      () => mockRepository.getAllTreasuries(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.getAllTreasuries()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
