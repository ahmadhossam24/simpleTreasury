import 'package:flutter_test/flutter_test.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';

void main() {
  group('Transaction Entity', () {
    final tTransaction1 = Transaction(
      id: '1',
      treasuryId: 'treasury123',
      title: 'Import Goods',
      value: 1000.0,
      date: DateTime(2025, 1, 1),
      type: TransactionType.import,
      deleted: false,
    );

    final tTransaction2 = Transaction(
      id: '1',
      treasuryId: 'treasury123',
      title: 'Import Goods',
      value: 1000.0,
      date: DateTime(2025, 1, 1),
      type: TransactionType.import,
      deleted: false,
    );

    final tTransactionDifferent = Transaction(
      id: '2',
      treasuryId: 'treasury123',
      title: 'Export Goods',
      value: 2000.0,
      date: DateTime(2025, 2, 1),
      type: TransactionType.export,
      deleted: false,
    );

    test('should support value equality', () {
      expect(tTransaction1, equals(tTransaction2));
      expect(tTransaction1.hashCode, equals(tTransaction2.hashCode));
    });

    test('should not be equal when properties differ', () {
      expect(tTransaction1, isNot(equals(tTransactionDifferent)));
    });

    test('should store correct property values', () {
      expect(tTransaction1.id, '1');
      expect(tTransaction1.treasuryId, 'treasury123');
      expect(tTransaction1.title, 'Import Goods');
      expect(tTransaction1.value, 1000.0);
      expect(tTransaction1.date, DateTime(2025, 1, 1));
      expect(tTransaction1.type, TransactionType.import);
      expect(tTransaction1.deleted, false);
    });
  });
}
