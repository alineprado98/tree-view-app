import 'package:tree_view_app/app/common/services/database/dtos/request/database_filter.dart';
import 'package:tree_view_app/app/common/services/database/dtos/response/database_response.dart';

abstract class IDatabase {
  Future<DatabaseResponse> insert({
    required String tableName,
    required Map<String, Object?> value,
  });
  Future<DatabaseResponse> get({
    DatabaseFilter? filters,
    required String tableName,
  });

  Future<DatabaseResponse> getById({
    required String tableName,
    required int id,
  });

  Future<DatabaseResponse> query({
    List<Object?>? params,
    required String query,
  });
  Future<DatabaseResponse> insertAll({
    required String tableName,
    required List<Map<String, Object?>> value,
  });
}
