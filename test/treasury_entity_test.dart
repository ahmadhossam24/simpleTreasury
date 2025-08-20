import 'package:flutter_test/flutter_test.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';

void main() {
  group("Treasury Entity", () {
    final tTreasury1 = Treasury(id: "1", title: "fatherCredit", deleted: false);
    final tTreasury2 = Treasury(id: "1", title: "fatherCredit", deleted: false);
    final tTreasuryDifferent = Treasury(
      id: "2",
      title: "fatherCredit",
      deleted: false,
    );
    test("should support value equality", () {
      expect(tTreasury1, equals(tTreasury2));
      expect(tTreasury1.hashCode, equals(tTreasury2.hashCode));
    });

    test("should not be equal when properties differ", () {
      expect(tTreasury1, isNot(equals(tTreasuryDifferent)));
    });

    test("should store correct properly values", () {
      expect(tTreasury1.id, "1");
      expect(tTreasury1.title, "fatherCredit");
      expect(tTreasury1.deleted, false);
    });
  });
}
