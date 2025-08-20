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


// what to test here and why 
// 1- Test that two Treasury objects with the same field values are considered equal.
// Test that changing one field makes them unequal.
// Reason: ensures Equatable is wired correctly with props.
// 2- Treasury props contains all fields