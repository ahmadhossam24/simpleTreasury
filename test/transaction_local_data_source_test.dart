import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpletreasury/core/database/db_provider.dart';
import 'package:simpletreasury/core/error/exceptions.dart';
import 'package:simpletreasury/features/transactions/data/dataSources/transaction_local_data_source.dart';
import 'package:simpletreasury/features/transactions/data/models/transaction_model.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class MockDatabase extends Mock implements sqflite.Database {}

class MockDBProvider extends Mock implements DBProvider {}

class FakeSqfliteDatabaseException extends sqflite.DatabaseException {
  FakeSqfliteDatabaseException(String super.message);

  @override
  int? getResultCode() {
    // TODO: implement getResultCode
    throw UnimplementedError();
  }

  @override
  // TODO: implement result
  Object? get result => throw UnimplementedError();
}

void main() {
  late MockDBProvider mockDBProvider;
  late MockDatabase mockDatabase;
  late TransactionLocalDataSourceImpl dataSource;

  final tTransactionModel = TransactionModel(
    id: '1',
    treasuryId: 'treasury1',
    title: 'Test Transaction',
    value: 100,
    date: DateTime(2023, 1, 1),
    type: TransactionType.import,
    deleted: false,
  );

  setUp(() {
    mockDBProvider = MockDBProvider();
    mockDatabase = MockDatabase();
    when(() => mockDBProvider.database).thenAnswer((_) async => mockDatabase);
    dataSource = TransactionLocalDataSourceImpl(dbProvider: mockDBProvider);
  });

  void runUnitMethodTest({
    required String methodName,
    required Future<Unit> Function() callMethod,
    required void Function() verifyCall,
  }) {
    group(methodName, () {
      test('should call correct db method and return unit', () async {
        when(
          () => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => mockDatabase.update(
            any(),
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => mockDatabase.delete(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await callMethod();

        expect(result, unit);
        verifyCall();
      });

      test(
        'should throw DatabaseException on sqflite.DatabaseException',
        () async {
          when(
            () => mockDatabase.insert(
              any(),
              any(),
              conflictAlgorithm: any(named: 'conflictAlgorithm'),
            ),
          ).thenThrow(FakeSqfliteDatabaseException('db fail'));
          when(
            () => mockDatabase.update(
              any(),
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(FakeSqfliteDatabaseException('db fail'));
          when(
            () => mockDatabase.delete(
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(FakeSqfliteDatabaseException('db fail'));

          expect(callMethod, throwsA(isA<DatabaseException>()));
        },
      );

      test('should throw UnexpectedException on unknown error', () async {
        when(
          () => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).thenThrow(Exception('oops'));
        when(
          () => mockDatabase.update(
            any(),
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          ),
        ).thenThrow(Exception('oops'));
        when(
          () => mockDatabase.delete(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          ),
        ).thenThrow(Exception('oops'));

        expect(callMethod, throwsA(isA<UnexpectedException>()));
      });
    });
  }

  runUnitMethodTest(
    methodName: 'addTransaction',
    callMethod: () => dataSource.addTransaction(tTransactionModel),
    verifyCall: () => verify(
      () => mockDatabase.insert(
        'transactions',
        any(),
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      ),
    ).called(1),
  );

  runUnitMethodTest(
    methodName: 'updateTransaction',
    callMethod: () => dataSource.updateTransaction(tTransactionModel),
    verifyCall: () => verify(
      () => mockDatabase.update(
        'transactions',
        any(),
        where: 'id = ?',
        whereArgs: [tTransactionModel.id],
      ),
    ).called(1),
  );

  runUnitMethodTest(
    methodName: 'deleteTransaction',
    callMethod: () => dataSource.deleteTransaction('1'),
    verifyCall: () => verify(
      () => mockDatabase.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: ['1'],
      ),
    ).called(1),
  );

  runUnitMethodTest(
    methodName: 'deleteTransactionsByTreasuryId',
    callMethod: () => dataSource.deleteTransactionsByTreasuryId('treasury1'),
    verifyCall: () => verify(
      () => mockDatabase.delete(
        'transactions',
        where: 'treasuryId = ?',
        whereArgs: ['treasury1'],
      ),
    ).called(1),
  );

  runUnitMethodTest(
    methodName: 'softDeleteTransaction',
    callMethod: () => dataSource.softDeleteTransaction('1'),
    verifyCall: () => verify(
      () => mockDatabase.update(
        'transactions',
        {'deleted': 1},
        where: 'id = ?',
        whereArgs: ['1'],
      ),
    ).called(1),
  );

  runUnitMethodTest(
    methodName: 'undoSoftDeleteTransaction',
    callMethod: () => dataSource.undoSoftDeleteTransaction('1'),
    verifyCall: () => verify(
      () => mockDatabase.update(
        'transactions',
        {'deleted': 0},
        where: 'id = ?',
        whereArgs: ['1'],
      ),
    ).called(1),
  );

  group('getAllTransactions', () {
    final dbMap = {
      'id': '1',
      'treasuryId': 'treasury1',
      'title': 'Test Transaction',
      'value': 100,
      'date': DateTime(2023, 1, 1).millisecondsSinceEpoch,
      'type': TransactionType.import.index,
      'deleted': 0,
    };

    test('should return List<TransactionModel> on success', () async {
      when(
        () => mockDatabase.query(
          any(),
          where: any(named: 'where'),
          whereArgs: any(named: 'whereArgs'),
          orderBy: any(named: 'orderBy'),
        ),
      ).thenAnswer((_) async => [dbMap]);

      final result = await dataSource.getAllTransactions('treasury1');

      expect(result, isA<List<TransactionModel>>());
      expect(result.first.id, '1');
    });

    test(
      'should throw DatabaseException on sqflite.DatabaseException',
      () async {
        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            orderBy: any(named: 'orderBy'),
          ),
        ).thenThrow(FakeSqfliteDatabaseException('db fail'));

        expect(
          () => dataSource.getAllTransactions('treasury1'),
          throwsA(isA<DatabaseException>()),
        );
      },
    );

    test('should throw UnexpectedException on unknown error', () async {
      when(
        () => mockDatabase.query(
          any(),
          where: any(named: 'where'),
          whereArgs: any(named: 'whereArgs'),
          orderBy: any(named: 'orderBy'),
        ),
      ).thenThrow(Exception('oops'));

      expect(
        () => dataSource.getAllTransactions('treasury1'),
        throwsA(isA<UnexpectedException>()),
      );
    });
  });
}
