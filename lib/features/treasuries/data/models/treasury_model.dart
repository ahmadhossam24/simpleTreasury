import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';

class TreasuryModel extends Treasury {
  const TreasuryModel({
    required super.id,
    required super.title,
    required super.deleted,
  });

  // 🧱 Construct from DB row
  factory TreasuryModel.fromMap(Map<String, dynamic> map) {
    return TreasuryModel(
      id: map['id'],
      title: map['title'],
      deleted: map['deleted'],
    );
  }

  // 🧱 Convert to DB row
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'deleted': deleted};
  }
}
