import 'package:equatable/equatable.dart';

class Treasury extends Equatable {
  final String id;
  final String title;
  final bool deleted;

  const Treasury({
    required this.id,
    required this.title,
    required this.deleted,
  });

  @override
  List<Object?> get props => [id, title, deleted];
}
