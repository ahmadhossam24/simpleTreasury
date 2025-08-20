import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/error/failures.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/repositories/treasuries_repository.dart';
import 'package:simpletreasury/features/treasuries/domain/usecases/add_treasury.dart';

// Mock class
class MockTreasuriesRepository extends Mock implements TreasuriesRepository {}

void main() {
  late AddTreasury usecase;
  late MockTreasuriesRepository mockRepository;

  final tTreasury = Treasury(id: '1', title: 'fatherCredit', deleted: false);

  setUp(() {
    mockRepository = MockTreasuriesRepository();
    usecase = AddTreasury(mockRepository);
  });

  test('should call repository.addTreasury and return Right(Unit) on success', () async {
    // arrange
    when(
      () => mockRepository.addTreasury(
        tTreasury,
      ), // This tells the mock: “If someone calls addTreasury() with any Treasury object, use my fake answer instead of calling real code.”
    ).thenAnswer(
      (_) async => const Right(unit),
    ); // This is the fake answer you give to the mock. Instead of actually hitting a database, the mock will pretend that the operation succeeded and return Right(unit) (which in Dartz means “success with no value, just a success signal”).
    // So basically, you’re saying: "Pretend the repository worked and returned success when addTreasury is called."

    // act
    final result = await usecase(
      tTreasury,
    ); //usecase(tTreasury) is shorthand for usecase.call(tTreasury) (since you wrote call in your usecase).
    // Inside the usecase, it calls the repository: return await repository.addTreasury(treasury);
    // But since you mocked the repository in the arrange phase, it won’t run real logic — it will return the fake result you defined (Right(unit)).
    // So the result will equal Right(unit).

    // assert
    expect(result, const Right(unit)); //  checks it returns success
    verify(
      () => mockRepository.addTreasury(tTreasury),
    ).called(1); //  checks repo called correctly
    verifyNoMoreInteractions(mockRepository); // ensures nothing else was called
  });

  test('should return Left(Failure) when repository fails', () async {
    // arrange
    const failure = DatabaseFailure('DB error');
    when(
      () => mockRepository.addTreasury(tTreasury),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tTreasury);

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.addTreasury(tTreasury)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
