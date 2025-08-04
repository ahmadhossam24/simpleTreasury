import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.treasuryId,
    required super.title,
    required super.value,
    required super.date,
    required super.type,
    required super.deleted,
  });

  // 🧱 Construct from DB row
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      treasuryId: map['treasuryId'],
      title: map['title'],
      value: map['value'],
      date: map['date'],
      type: map['type'],
      deleted: map['deleted'],
    );
  }

  // 🧱 Convert to DB row
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'treasuryId': treasuryId,
      'title': title,
      'value': value,
      'date': date,
      'type': type,
      'deleted': deleted,
    };
  }

  // Column names in toMap() should match the actual column names in your CREATE TABLE SQL.

  // If date is a DateTime, consider converting it to String (e.g. ISO 8601 format) or epoch time to store it in SQLite, depending on how you want to query it.
}


  // factory TransactionModel.fromJson(Map<String, dynamic> json) {
  //   return TransactionModel(
  //     id: json['id'],
  //     treasuryId: json['treasuryId'],
  //     title: json['title'],
  //     value: json['value'],
  //     date: json['date'],
  //     type: json['type'],
  //     deleted: json['deleted'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'treasuryId': treasuryId,
  //     'title': title,
  //     'value': value,
  //     'date': date,
  //     'type': type,
  //     'deleted': deleted,
  //   };
  // }
