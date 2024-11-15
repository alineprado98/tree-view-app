import 'package:tree_view_app/app/core/services/database/dtos/response/database_data.dart';
import 'package:tree_view_app/app/core/services/database/dtos/response/database_error.dart';

class DatabaseResponse {
  final DatabaseData? data;
  final DatabaseError? error;

  DatabaseResponse({this.data, this.error});
}
