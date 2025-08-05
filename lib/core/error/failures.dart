import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

// probable failures i want to add :
// Database lifecycle: open/init, migration, corruption, closed/locked DB
// I/O & device state: storage full, permission denied
// Catch‑all: unknown/unexpected
