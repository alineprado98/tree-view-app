/// A class that represents a filter for database queries.
/// [limit] is the maximum number of items to return (default is 20).
/// [distinct] indicates whether to return only distinct results (default is false).
/// [page] is the current page of the query (default is 1).
/// [orderBy] defines the field by which results should be sorted.
/// [whereArgs] is a list of conditions for filtering results.
/// [like] is a map of conditions using LIKE for filtering.
/// [groupBy] specifies the field(s) to group results.
/// [having] defines additional conditions for the results after aggregation.
/// [whereClause] specifies how to combine multiple WHERE conditions (default is AND).

class DatabaseFilter {
  final int limit;
  final bool distinct;
  final int page;
  final String? orderBy;
  final List<Map<String, dynamic>>? whereArgs;
  final Map<String, dynamic>? like;
  final String? groupBy;
  final String? having;
  final WhereClause whereClause;

  DatabaseFilter({
    this.limit = 20,
    this.page = 1,
    this.whereClause = WhereClause.AND,
    this.orderBy,
    this.groupBy,
    this.having,
    this.whereArgs,
    this.like,
    this.distinct = false,
  });

  int get offeset => (page - 1) * limit;

  (String?, List<Object?>?) get where {
    List<String> conditions = [];
    List<Object?>? args = [];

    if (like != null) {
      like!.forEach((column, value) {
        conditions.add('$column LIKE ?');
        args.add('$value%');
      });
    }

    if (whereArgs?.isNotEmpty ?? false) {
      for (var item in whereArgs!) {
        item.forEach((key, value) {
          conditions.add('$key=?');
          args.add(value);
        });
      }
    }

    final whereFormatted = conditions.isNotEmpty ? conditions.join(' AND ') : null;

    return (whereFormatted, args);
  }
}

enum WhereClause {
  AND,
  OR,
}
