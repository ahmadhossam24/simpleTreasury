import 'package:equatable/equatable.dart';

enum TransactionType { import, export }

class Transaction extends Equatable {
  final String id;
  final String title;
  final double value;
  final DateTime date;
  final TransactionType type;
  final bool deleted;

  const Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
    required this.type,
    required this.deleted,
  });

  @override
  List<Object?> get props => [id, title, value, date, type, deleted];
}
