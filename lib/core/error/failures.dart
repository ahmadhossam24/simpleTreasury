import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class DatabaseFailure extends Failure {
  final String message;

  DatabaseFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {
  final String message;

  UnknownFailure(this.message);

  @override
  List<Object?> get props => [message];
}
// probable failures i want to add :
// Database lifecycle: open/init, migration, corruption, closed/locked DB
// I/O & device state: storage full, permission denied
// Catch‑all: unknown/unexpected