import 'package:flutter_test/flutter_test.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury_with_transactions.dart';

void main() {
  group("Treasury with transactions Entity", () {
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
      id: '2',
      treasuryId: 'treasuryxxx',
      title: 'Import Goods',
      value: 1000.0,
      date: DateTime(2025, 1, 1),
      type: TransactionType.export,
      deleted: false,
    );
    final tTreasury1 = Treasury(id: "1", title: "fatherCredit", deleted: false);
    final tTreasuryWithTransactions1 = TreasuryWithTransactions(
      treasury: tTreasury1,
      transactions: [tTransaction1, tTransaction2],
    );
    final tTreasuryWithTransactions2 = TreasuryWithTransactions(
      treasury: tTreasury1,
      transactions: [tTransaction1, tTransaction2],
    );
    final tTreasuryWithTransactionsDifferent = TreasuryWithTransactions(
      treasury: tTreasury1,
      transactions: [tTransaction1],
    );
    test("should support value equality", () {
      expect(tTreasuryWithTransactions1, equals(tTreasuryWithTransactions2));
      expect(
        tTreasuryWithTransactions1.hashCode,
        equals(tTreasuryWithTransactions2.hashCode),
      );
    });

    test("should not be equal when properties differ", () {
      expect(
        tTreasuryWithTransactions1,
        isNot(equals(tTreasuryWithTransactionsDifferent)),
      );
    });

    test("should store correct properly values", () {
      expect(tTreasuryWithTransactions1.treasury, tTreasury1);
      expect(tTreasuryWithTransactions1.transactions, [
        tTransaction1,
        tTransaction2,
      ]);
    });
  });
}
