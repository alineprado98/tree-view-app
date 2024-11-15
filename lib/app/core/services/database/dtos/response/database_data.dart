class DatabaseData {
  final int limit;
  final int page;
  final int total;
  final int totalPages;
  final int nextPage;
  final int previousPage;
  final List<Map<String, Object?>> result;

  const DatabaseData({
    required this.result,
    this.limit = 20,
    this.page = 1,
    this.total = 0,
    this.nextPage = 1,
    this.totalPages = 1,
    this.previousPage = 1,
  });
}
