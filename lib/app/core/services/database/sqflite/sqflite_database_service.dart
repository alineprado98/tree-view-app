import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:tree_view_app/app/core/services/database/dtos/request/database_filter.dart';
import 'package:tree_view_app/app/core/services/database/dtos/response/database_data.dart';
import 'package:tree_view_app/app/core/services/database/dtos/response/database_error.dart';
import 'package:tree_view_app/app/core/services/database/dtos/response/database_response.dart';
import 'package:tree_view_app/app/core/services/database/i_database.dart';
import 'package:tree_view_app/app/core/services/database/sqflite/sqflite_config.dart';

class SqfliteDatabaseService implements IDatabase {
  late final Database database;
  final SqfliteConfig databaseConfig;

  SqfliteDatabaseService({required this.databaseConfig}) {
    database = databaseConfig.db;
  }

  @override
  Future<DatabaseResponse> get({DatabaseFilter? filters, required String tableName}) async {
    try {
      final response = await database.query(
        tableName,
        distinct: filters?.distinct,
        where: filters?.where.$1,
        whereArgs: filters?.where.$2,
        groupBy: filters?.groupBy,
        having: filters?.having,
        orderBy: filters?.orderBy,
        limit: filters?.limit,
        offset: filters?.offeset,
      );
      final countResponse = await database.rawQuery('SELECT COUNT(*) as total FROM  $tableName');
      final int total = countResponse.isNotEmpty ? countResponse[0]['total'] as int : 0;

      late final DatabaseData result;
      if (filters != null) {
        result = DatabaseData(
          result: response.toList(),
          page: filters.page,
          total: total,
          limit: filters.limit,
          nextPage: filters.page + 1,
          previousPage: filters.page,
          totalPages: (total / filters.limit).ceil(),
        );
      } else {
        result = DatabaseData(result: response.toList());
      }
      return DatabaseResponse(data: result);
    } catch (e, stackTrace) {
      return DatabaseResponse(
          data: null,
          error: DatabaseError(
            message: 'Error retrieving data from table $tableName: $e',
            stackTrace: stackTrace,
          ));
    }
  }

  @override
  Future<DatabaseResponse> insert({required String tableName, required Map<String, Object?> value}) async {
    late Batch batch;
    try {
      await database.transaction((txn) async {
        batch = txn.batch();

        batch.insert(tableName, value);
        await batch.commit();
      });
      return DatabaseResponse();
    } catch (e, stackTrace) {
      return DatabaseResponse(
          data: null,
          error: DatabaseError(
            message: 'Error inserting data into table $tableName: $e',
            stackTrace: stackTrace,
          ));
    }
  }

  @override
  Future<DatabaseResponse> getById({required String tableName, required int id}) async {
    late Batch batch;
    try {
      await database.transaction((txn) async {
        batch = txn.batch();
        batch.query(tableName, where: 'id=?', whereArgs: [id]);
        await batch.commit(continueOnError: false);
      });
      return DatabaseResponse();
    } catch (e, stackTrace) {
      return DatabaseResponse(
          data: null,
          error: DatabaseError(
            message: 'Error retrieving record with id $id from table $tableName: $e',
            stackTrace: stackTrace,
          ));
    }
  }

  @override
  Future<DatabaseResponse> insertAll({required String tableName, required List<Map<String, Object?>> value}) async {
    late Batch batch;
    try {
      await database.transaction((txn) async {
        batch = txn.batch();
        for (var item in value) {
          batch.insert(tableName, item);
        }
        await batch.commit(continueOnError: false);
      });

      return DatabaseResponse();
    } catch (e, stackTrace) {
      return DatabaseResponse(
          data: null,
          error: DatabaseError(
            message: 'Error inserting multiple records into table $tableName: $e',
            stackTrace: stackTrace,
          ));
    }
  }

  @override
  Future<DatabaseResponse> query({required String query}) async {
    try {
      final response = await database.rawQuery(query);
      DatabaseData result = DatabaseData(result: response.toList());
      return DatabaseResponse(data: result);
    } catch (e, stackTrace) {
      return DatabaseResponse(
          data: null,
          error: DatabaseError(
            message: 'Error executing query: $query. Error: $e',
            stackTrace: stackTrace,
          ));
    }
  }
}
