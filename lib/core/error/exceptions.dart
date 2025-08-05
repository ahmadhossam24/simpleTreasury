class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache Error']);
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException([this.message = 'Database Error']);
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException([this.message = 'Unexpected Error']);
}
