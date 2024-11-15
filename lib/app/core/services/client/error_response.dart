class ErrorResponse implements Exception {
  final String message;
  final StackTrace? stackTrace;

  ErrorResponse({required this.message, required this.stackTrace});
}
