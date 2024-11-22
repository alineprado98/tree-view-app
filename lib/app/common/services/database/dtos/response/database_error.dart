class DatabaseError implements Exception {
  final String message;
  final StackTrace? stackTrace;

  DatabaseError({required this.message, required this.stackTrace});
}
